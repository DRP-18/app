import 'dart:isolate';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tutor_me/bloc/files.dart';
import 'package:tutor_me/components/viewer.dart';
import 'package:tutor_me/theme/theme.dart';
import 'package:path_provider/path_provider.dart';

class FileViewer extends RefreshableViewer<UserFile, FileBloc> {
  final String _taskID;
  final String _userID;
  final DateFormat _format = DateFormat("HH:mm dd MMM");
  final _url = "https://tutor-drp.herokuapp.com/file/";

  FileViewer(this._taskID, this._userID);

  @override
  List<Widget> children(BuildContext context) {
    final FileBloc _fileBloc = BlocProvider.of(context);
    return [
      DummyDownloader(),
      IconButton(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();

          if(result != null) {
            _fileBloc.add(UploadFile(result.files.single));
          }
          },
          icon: Icon(Icons.upload_file, color: mainTheme.accentColor)),
    ];
  }

  @override
  List<Widget> process(List<UserFile> state, BuildContext context) {
    return state
        .map((file) => Card(
                child: ListTile(
              title: Text(file.name),
              subtitle: Text(
                  "${file.uploader} at ${_format.format(file.uploadTime)}"),
              trailing: IconButton(
                onPressed: () async {
                  await _downloadFile(file);
                },
                icon: Icon(Icons.download, color: mainTheme.primaryColor),
              ),
            )))
        .toList();
  }

  Future<void> _downloadFile(UserFile file) async {
    final status = await Permission.storage.request();

    final url = _url + """${file.id}/${file.name.replaceAll(" ", "%20")}""";

    if (status.isGranted) {
      final externalDir = await getExternalStorageDirectory();

      final taskID = await FlutterDownloader.enqueue(
        url: url,
        savedDir: externalDir!.path,
        showNotification: true,
        openFileFromNotification: true,
      );
      await FlutterDownloader.open(taskId: taskID!);
    } else {
      print("Permission denied");
    }
  }

  @override
  Future<List<UserFile>> refresher(BuildContext context) async {
    return await RefreshFile().handle([_taskID, _userID]);
  }
}

class DummyDownloader extends StatefulWidget {
  const DummyDownloader({Key? key}) : super(key: key);

  @override
  _DummyDownloaderState createState() => _DummyDownloaderState();
}

class _DummyDownloaderState extends State<DummyDownloader> {
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) => setState(() {}));

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
        print("hello");
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
