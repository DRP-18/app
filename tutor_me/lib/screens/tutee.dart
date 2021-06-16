import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_me/bloc/task.dart';
import 'package:tutor_me/components/task_viewer.dart';
import 'package:tutor_me/components/users.dart';
import 'package:tutor_me/theme/theme.dart';

class TuteeScreen extends StatelessWidget {
  final String _name;
  final String _userID;
  final String _tuteeID;

  const TuteeScreen(this._userID, this._tuteeID, this._name, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        body: BlocProvider<TaskBloc>(
          create: (context) =>
              TaskBloc(_userID, _tuteeID)..add(RefreshTask(_name)),
          child: TaskViewer(UserType.Tutor, _name, _userID),
        ));
  }
}
