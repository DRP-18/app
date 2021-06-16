import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tutor_me/bloc/files.dart';
import 'package:tutor_me/components/viewer.dart';
import 'package:tutor_me/theme/theme.dart';

class FileViewer extends RefreshableViewer<File, FileBloc> {
  final String _taskID;
  final DateFormat _format = DateFormat("HH:mm dd MMM");

  FileViewer(this._taskID);

  @override
  List<Widget> children(BuildContext context) {
    final FileBloc _fileBloc = BlocProvider.of(context);
    return [
      IconButton(
          onPressed: () {},
          icon: Icon(Icons.upload_file, color: mainTheme.accentColor))
    ];
  }

  @override
  List<Widget> process(List<File> state, BuildContext context) {
    return state.map((e) => Card(
      child: ListTile(
        title: Text(e.name),
        subtitle: Text("${e.uploader} at ${_format.format(e.uploadTime)}"),
      )
    )).toList();
  }

  @override
  Future<List<File>> refresher(BuildContext context) async {
    return await RefreshFile().handle([_taskID]);
  }
}
