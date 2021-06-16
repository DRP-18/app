import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_me/bloc/files.dart';
import 'package:tutor_me/components/file_viewer.dart';
import 'package:tutor_me/theme/theme.dart';

class FileScreen extends StatelessWidget {
  final String _taskID;
  final String _name;

  const FileScreen(this._name, this._taskID, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FileBloc _fileBloc = FileBloc(_taskID);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _name,
          style: textStyle.copyWith(color: mainTheme.primaryColor),
        ),
        backgroundColor: mainTheme.accentColor,
        foregroundColor: mainTheme.primaryColor,
      ),
      backgroundColor: mainTheme.primaryColor,
      body: BlocProvider<FileBloc>(
        create: (context) => FileBloc(_taskID)..add(RefreshFile()),
        child: FileViewer(_taskID),
      ),
    );
  }
}
