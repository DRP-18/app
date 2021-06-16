import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:intl/intl.dart';

import 'data_bloc.dart';

class FileBloc extends DataBloc<File> {
  final String _taskID;

  FileBloc(this._taskID) : super([_taskID]);
}

class File {
  final String _name;
  final String _uploader;
  final DateTime _uploadTime;
  final int _id;

  const File(this._name, this._uploader, this._uploadTime, this._id);

  static File fromJson(Map obj) {
    final _format = DateFormat("yyyy-MM-ddThh:mm");
    return File(
      obj["filename"]!,
      obj["uploader"]!["name"]!,
      _format.parse(obj["uploadTime"]!),
      obj["id"]!
    );
  }
}


class RefreshFile extends Refresh<File> {
  final _url = "https://tutor-drp.herokuapp.com/task/";

  RefreshFile() : super((v) => File.fromJson(v));

  @override
  Future<http.Response> request(List<String> fields) {
    final _taskID = fields[0];
    final url = Uri.parse(_url + _taskID);
    return http.get(url);
  }
}
