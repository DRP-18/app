import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_me/bloc/task.dart';
import 'package:tutor_me/bloc/tutees.dart' as tutees;
import 'package:tutor_me/components/drawer.dart';
import 'package:tutor_me/components/task_viewer.dart';
import 'package:tutor_me/components/tutee_viewer.dart';
import 'package:tutor_me/components/users.dart';
import 'package:tutor_me/theme/theme.dart';

class HomeScreen extends StatelessWidget {
  final String _userID;
  final UserType _uType;

  const HomeScreen(this._userID, this._uType, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: textStyle.copyWith(color: mainTheme.primaryColor),
        ),
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(Icons.menu, color: mainTheme.primaryColor)),
        ),
        backgroundColor: mainTheme.accentColor,
      ),
      backgroundColor: mainTheme.primaryColor,
      body: _uType == UserType.Tutee
          ? BlocProvider<TaskBloc>(
              create: (context) =>
                  TaskBloc(_userID, _userID)..add(RefreshTask(null)),
              child: TaskViewer(_uType, null, _userID),
            )
          : BlocProvider<tutees.TuteeBloc>(
              create: (context) =>
                  tutees.TuteeBloc(_userID)..add(tutees.RefreshTutee()),
              child: TuteeViewer(),
            ),
      drawer: MainDrawer(_userID),
    );
  }
}
