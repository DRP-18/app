import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_me/bloc/task.dart';
import 'package:tutor_me/components/users.dart';
import 'package:tutor_me/components/viewer.dart';

class TaskViewer extends RefreshableViewer<Task, TaskBloc> {
  final UserType _uType;
  final String? _tuteeName;
  final String _userID;
  const TaskViewer(this._uType, this._tuteeName, this._userID);

  @override
  List<StatelessWidget> process(List<Task> state) => state
      .where((e) => e.end.isAfter(DateTime.now()))
      .map((e) =>
          _uType == UserType.Tutee ? TuteeCard(e) : TutorCard(e, _tuteeName!))
      .toList();

  @override
  Future<List<Task>> refresher(BuildContext context) {
    final TaskBloc _taskBloc = BlocProvider.of(context);
    return RefreshTask(null).handle([this._userID, _taskBloc.tuteeID]);
  }

  @override
  List<Widget> children(BuildContext context) {
    final TaskBloc _taskBloc = BlocProvider.of(context);
    return [
      if (_uType == UserType.Tutor)
        ElevatedButton(
            onPressed: () {
              _taskBloc.add(AddTask(
                  Task(DateTime.now(), DateTime.now().add(Duration(days: 1)),
                      "Homework 1", false),
                  _tuteeName!));
            },
            child: Text("Add")),
    ];
  }
}
