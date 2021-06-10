import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class CalendarBloc extends Bloc<CalendarEvent, List<Task>> {
  final String userID;

  CalendarBloc(this.userID) : super([]);

  List<Task> get initialState => [];

  @override
  Stream<List<Task>> mapEventToState(CalendarEvent event) async* {
    yield await event.handle(userID);
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
  Future<List<Task>> handle(String userID);
}

class Add extends CalendarEvent {
  final _format = DateFormat("yyyy-MM-ddThh:mm");
  final Uri url = Uri.parse("https://tutor-drp.herokuapp.com/addtask");
  
  late Task _task;
  late String _tuteeName;

  Add(Task task, String tuteeName) {
    _task = task;
    _tuteeName = tuteeName;
  }

  @override
  Future<List<Task>> handle(String userID) async {
    await http.post(url, headers: {
      "Cookie": "user_id=$userID",
    }, body: {
      "start_time": _formatTime(_task.start),
      "end_time": _formatTime(_task.end),
      "content": _task.content,
      "tutee_id": _task.id.toString(),
    });
    return Refresh(_tuteeName).handle(userID);
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
  Future<List<Task>> handle(String userID) async {
    await http.post(url, headers: {
      "Cookie": "user_id=$userID",
    }, body: {
      "task_id": "$_id",
    });
    return Refresh(_tuteeName).handle(userID);
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
  Future<List<Task>> handle(String userID) async {
    var resp = await http.post(url, headers: {"Cookie": "user_id=$userID${_tuteeName == null ? "" : ";tutee_name=$_tuteeName"}"});
    var rawTasks = json.decode(utf8.decode(resp.bodyBytes));
    return _parseTasks(rawTasks);
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
