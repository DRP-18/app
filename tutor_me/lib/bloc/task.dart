import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:intl/intl.dart';
import 'data_bloc.dart';

class TaskBloc extends DataBloc<Task> {
  final String _userID;
  final String _tuteeID;

  TaskBloc(this._userID, this._tuteeID) : super([_userID, _tuteeID]);

  @override
  Stream<List<Task>> mapEventToState(DataEvent<Task> event) async* {
    switch (event.runtimeType) {
      case AddTask:
        var add = event as AddTask;
        yield this.state + [add._task];
        break;
      case RemoveTask:
        var rem = event as RemoveTask;
        yield this.state.where((element) => element.id != rem._id).toList();
        break;
      case DoneTask:
        var done = event as DoneTask;
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
    super.mapEventToState(event);
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

  static Task fromJson(Map obj) {
    return Task(
      DateTime.parse(obj["startTime"]!),
      DateTime.parse(obj["endTime"]!),
      obj["content"]!,
      obj["done"]!,
      obj["id"]!,
    );
  }
}

class RefreshTask extends Refresh<Task> {
  final _url = Uri.parse("https://tutor-drp.herokuapp.com/tuteetasks");
  final String? _tuteeName;

  RefreshTask(this._tuteeName) : super((v) => Task.fromJson(v));

  @override
  Future<http.Response> request(List<String> fields) {
    final tuteeID = fields[1];
    return http.get(_url, headers: {
      "Cookie":
          "user_id=$tuteeID${_tuteeName == null ? "" : ";tutee_name=$_tuteeName"}"
    });
  }
}

class DoneTask extends DataEvent<Task> {
  final url = Uri.parse("https://tutor-drp.herokuapp.com/donetask");
  late int _id;

  DoneTask(int id) {
    this._id = id;
  }

  Future<List<Task>> handle(List<String> fields) async {
    final userID = fields[0];
    await http.post(url, headers: {
      "Cookie": "user_id=$userID",
    }, body: {
      "task_id": "$_id",
    });
    return RefreshTask("Mika").handle(fields);
  }
}

class RemoveTask extends DataEvent<Task> {
  final url = Uri.parse("https://tutor-drp.herokuapp.com/deletetask");
  late int _id;
  late String _tuteeName;

  RemoveTask(int id, String tuteeName) {
    _id = id;
    _tuteeName = tuteeName;
  }

  @override
  Future<List<Task>> handle(List<String> fields) async {
    final userID = fields[0];
    await http.post(url, headers: {
      "Cookie": "user_id=$userID",
    }, body: {
      "task_id": "$_id",
    });
    return RefreshTask(_tuteeName).handle(fields);
  }
}

class AddTask extends DataEvent<Task> {
  final _format = DateFormat("yyyy-MM-ddThh:mm");
  final Uri url = Uri.parse("https://tutor-drp.herokuapp.com/addtask");

  late Task _task;
  late String _tuteeName;

  AddTask(Task task, String tuteeName) {
    _task = task;
    _tuteeName = tuteeName;
  }

  @override
  Future<List<Task>> handle(List<String> fields) async {
    final userID = fields[0];
    final tuteeID = fields[1];
    await http.post(url, headers: {
      "Cookie": "user_id=$userID",
    }, body: {
      "start_time": _formatTime(_task.start),
      "end_time": _formatTime(_task.end),
      "content": _task.content,
      "tutee_id": tuteeID,
    });
    return RefreshTask(_tuteeName).handle(fields);
  }

  String _formatTime(DateTime time) {
    return _format.format(time);
  }
}
