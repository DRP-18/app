import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:intl/intl.dart';

import 'data_bloc.dart';

class FileBloc extends DataBloc<File> {
  final String _taskID;

  FileBloc(this._taskID) : super([_taskID]);

  @override
  Stream<List<File>> mapEventToState(DataEvent<File> event) async* {
    yield await event.handle([_taskID]);
  }
}

class File {
  // ignore: unused_field
  final String name;
  // ignore: unused_field
  final String uploader;
  // ignore: unused_field
  final DateTime uploadTime;
  // ignore: unused_field
  final int id;

  const File(this.name, this.uploader, this.uploadTime, this.id);

  static File fromJson(Map obj) {
    final _format = DateFormat("yyyy-MM-ddThh:mm");
    return File(obj["filename"]!, obj["uploader"]!["name"]!,
        _format.parse(obj["uploadTime"]!), obj["id"]!);
  }
}

class RefreshFile extends Refresh<File> {
  final _url = "https://tutor-drp.herokuapp.com/taskfiles?task_id=";

  RefreshFile() : super();

  @override
  Future<http.Response> request(List<String> fields) {
    final _taskID = fields[0];
    final url = Uri.parse(_url + _taskID);
    return http.get(url, headers: {
      "Cookie": "user_id=1",
    });
  }

  @override
  File dataConstructor(Map obj) {
    return File.fromJson(obj);
  }
}
