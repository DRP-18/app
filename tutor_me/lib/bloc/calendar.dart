import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class CalendarBloc extends Bloc<CalendarEvent, List<Task>> {
  final String userID;
  final String tuteeID;

  CalendarBloc(this.userID, this.tuteeID) : super([]);

  List<Task> get initialState => [];

  @override
  Stream<List<Task>> mapEventToState(CalendarEvent event) async* {
    yield await event.handle(userID, tuteeID);
  }
}

class Task {
  late int? id;
  late DateTime start;
  late DateTime end;
  late String content;

  Task(DateTime start, DateTime end, String content, [int? id]) {
    this.start = start;
    this.end = end;
    this.content = content;
    this.id = id;
  }
}

abstract class CalendarEvent {
  Future<List<Task>> handle(String userID, String tuteeID);
}

class Add extends CalendarEvent {
  final _format = DateFormat("yyyy-MM-ddThh:mm");
  // final Uri url = Uri.parse("https://tutor-drp.herokuapp.com/addtask");
  final Uri url = Uri.parse("http://192.168.1.118:8080/addtask");
  
  late Task _task;
  late String _tuteeName;

  Add(Task task, String tuteeName) {
    _task = task;
    _tuteeName = tuteeName;
  }

  @override
  Future<List<Task>> handle(String userID, String tuteeID) async {
    var resp = await http.post(url, headers: {
      "Cookie": "user_id=$userID",
    }, body: {
      "start_time": _formatTime(_task.start),
      "end_time": _formatTime(_task.end),
      "content": _task.content,
      "tutee_id": tuteeID,
    });
    print(resp);
    return Refresh(_tuteeName).handle(userID, tuteeID);
  }

  String _formatTime(DateTime time) {
    return _format.format(time);
  }
}

class Remove extends CalendarEvent {
  final url = Uri.parse("http://192.168.1.118:8080/deletetask");
  late int _id;
  late String _tuteeName;

  Remove(int id, String tuteeName) {
    _id = id;
    _tuteeName = tuteeName;
  }

  @override
  Future<List<Task>> handle(String userID, String tuteeID) async {
    await http.post(url, headers: {
      "Cookie": "user_id=$userID",
    }, body: {
      "task_id": "$_id",
    });
    return Refresh(_tuteeName).handle(userID, tuteeID);
  }
}

class Refresh extends CalendarEvent {
  final url = Uri.parse("http://192.168.1.118:8080/viewtask");
  late String? _tuteeName;

  Refresh(String? tuteeName) {
    this._tuteeName = tuteeName;
  }

  // final url = Uri.parse("https://tutor-drp.herokuapp.com/viewtask");
  final DateFormat format = DateFormat("E MMM dd HH:mm:ss yyyy");

  @override
  Future<List<Task>> handle(String _, String tuteeID) async {
    var resp = await http.post(url, headers: {"Cookie": "user_id=$tuteeID${_tuteeName == null ? "" : ";tutee_name=$_tuteeName"}"});
    if (resp.statusCode != 200) {
      return List.empty();
    }
    var rawTasks = json.decode(utf8.decode(resp.bodyBytes));
    var tasks = _parseTasks(rawTasks);
    return tasks;
  }

  List<Task> _parseTasks(List raw) {
    return raw.map((e) => _parseTask(e as Map)).toList();
  }

  Task _parseTask(Map obj) {
    return Task(
      _parseTime(obj["start_time"]!),
      _parseTime(obj["end_time"]!),
      obj["content"]!,
      obj["id"]!,
    );
  }

  DateTime _parseTime(String timeString) {
    return format.parseUTC(timeString.replaceRange(20, 24, ""));
  }
}
