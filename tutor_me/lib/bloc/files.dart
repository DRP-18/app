
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:intl/intl.dart';

import 'data_bloc.dart';

class FileBloc extends DataBloc<UserFile> {
  final String _taskID;
  final String _userID;

  FileBloc(this._taskID, this._userID) : super([_taskID]);

  @override
  Stream<List<UserFile>> mapEventToState(DataEvent<UserFile> event) async* {
    yield await event.handle([_taskID, _userID]);
  }
}

class UserFile {
  final String name;
  final String uploader;
  final DateTime uploadTime;
  final int id;

  const UserFile(this.name, this.uploader, this.uploadTime, this.id);

  static UserFile fromJson(Map obj) {
    final _format = DateFormat("yyyy-MM-ddThh:mm");
    return UserFile(obj["filename"]!, obj["uploader"]!["name"]!,
        _format.parse(obj["uploadTime"]!), obj["id"]!);
  }
}

class RefreshFile extends Refresh<UserFile> {
  final _url = "https://tutor-drp.herokuapp.com/taskfiles?task_id=";

  RefreshFile() : super();

  @override
  Future<http.Response> request(List<String> fields) {
    final _taskID = fields[0];
    final _userID = fields[1];
    final url = Uri.parse(_url + _taskID);
    return http.get(url, headers: {
      "Cookie": "user_id=$_userID",
    });
  }

  @override
  UserFile dataConstructor(Map obj) {
    return UserFile.fromJson(obj);
  }
}

class UploadFile extends DataEvent<UserFile> {
  final _url = Uri.parse("https://tutor-drp.herokuapp.com/uploadtaskfile");
  final PlatformFile _file;

  UploadFile(this._file);

  @override
  Future<List<UserFile>> handle(List<String> fields) async {
    final _taskID = fields[0];
    final _userID = fields[1];

    var request = http.MultipartRequest('POST', _url);

    request.files.add(await http.MultipartFile.fromPath("file", _file.path!));
    request.fields["task_id"] = _taskID;
    request.headers["Cookie"] = "user_id=$_userID";

    var res = await request.send();
    print(res);

    return RefreshFile().handle(fields);
  }
}
