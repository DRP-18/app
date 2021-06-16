import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_me/bloc/files.dart';
import 'package:tutor_me/components/file_viewer.dart';
import 'package:tutor_me/theme/theme.dart';

class FileScreen extends StatelessWidget {
  final String _taskID;
  final String _userID;
  final String _name;

  const FileScreen(this._name, this._taskID, this._userID, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _name,
          style: textStyle.copyWith(color: mainTheme.primaryColor),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: mainTheme.primaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: mainTheme.accentColor,
        foregroundColor: mainTheme.primaryColor,
      ),
      backgroundColor: mainTheme.primaryColor,
      body: BlocProvider<FileBloc>(
        create: (context) => FileBloc(_taskID, _userID)..add(RefreshFile()),
        child: FileViewer(_taskID, _userID),
      ),
    );
  }
}
