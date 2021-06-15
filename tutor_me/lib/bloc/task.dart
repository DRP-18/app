import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';

class TaskBloc extends Bloc<TaskEvent, List<Task>> {
  final String userID;
  final String tuteeID;

  TaskBloc(this.userID, this.tuteeID) : super([]);

  List<Task> get initialState => [];

  @override
  Stream<List<Task>> mapEventToState(TaskEvent event) async* {
    switch (event.runtimeType) {
      case Add:
        var add = event as Add;
        yield this.state + [add._task];
        break;
      case Remove:
        var rem = event as Remove;
        yield this.state.where((element) => element.id != rem._id).toList();
        break;
      case Done:
        var done = event as Done;
        yield this
            .state
            .map((task) => task.id == done._id
                ? Task(task.start, task.end, task.content, true, task.id)
                : task)
            .toList();
        break;
      default:
        break;
    }
    yield await event.handle(userID, tuteeID);
  }
}

class Task {
  late int? id;
  late DateTime start;
  late DateTime end;
  late String content;
  late bool done;

  Task(DateTime start, DateTime end, String content, bool done, [int? id]) {
    this.start = start;
    this.end = end;
    this.content = content;
    this.id = id;
    this.done = done;
  }
}

abstract class TaskEvent {
  Future<List<Task>> handle(String userID, String tuteeID);
}

class Add extends TaskEvent {
  final _format = DateFormat("yyyy-MM-ddThh:mm");
  final Uri url = Uri.parse("https://tutor-drp.herokuapp.com/addtask");

  late Task _task;
  late String _tuteeName;

  Add(Task task, String tuteeName) {
    _task = task;
    _tuteeName = tuteeName;
  }

  @override
  Future<List<Task>> handle(String userID, String tuteeID) async {
    await http.post(url, headers: {
      "Cookie": "user_id=$userID",
    }, body: {
      "start_time": _formatTime(_task.start),
      "end_time": _formatTime(_task.end),
      "content": _task.content,
      "tutee_id": tuteeID,
    });
    return Refresh(_tuteeName).handle(userID, tuteeID);
  }

  String _formatTime(DateTime time) {
    return _format.format(time);
  }
}

class Remove extends TaskEvent {
  final url = Uri.parse("https://tutor-drp.herokuapp.com/deletetask");
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

class Refresh extends TaskEvent {
  final url = Uri.parse("https://tutor-drp.herokuapp.com/tuteetasks");
  late String? _tuteeName; //Needed to know which tutee to get data for

  Refresh(String? tuteeName) {
    this._tuteeName = tuteeName;
  }

  final DateFormat format = DateFormat("Y");

  @override
  Future<List<Task>> handle(String _, String tuteeID) async {
    var resp = await http.get(url, headers: {
      "Cookie":
          "user_id=$tuteeID${_tuteeName == null ? "" : ";tutee_name=$_tuteeName"}"
    });
    if (resp.statusCode != 200) {
      return List.empty();
    }
    var rawTasks = json.decode(resp.body);
    var tasks = _parseTasks(rawTasks);
    return tasks;
  }

  List<Task> _parseTasks(List raw) {
    return raw.map((e) => _parseTask(e as Map)).toList();
  }

  Task _parseTask(Map obj) {
    return Task(
      _parseTime(obj["startTime"]!),
      _parseTime(obj["endTime"]!),
      obj["content"]!,
      obj["done"]!,
      obj["id"]!,
    );
  }

  DateTime _parseTime(String timeString) {
    return DateTime.parse(timeString);
  }
}

class Done extends TaskEvent {
  final url = Uri.parse("https://tutor-drp.herokuapp.com/donetask");
  late int _id;

  Done(int id) {
    this._id = id;
  }

  Future<List<Task>> handle(String userID, String tuteeID) async {
    await http.post(url, headers: {
      "Cookie": "user_id=$userID",
    }, body: {
      "task_id": "$_id",
    });
    return Refresh("Mika").handle(userID, tuteeID);
  }
}
