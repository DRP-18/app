import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prompt_dialog/prompt_dialog.dart';
import 'package:tutor_me/bloc/task.dart';
import 'package:tutor_me/components/users.dart';
import 'package:tutor_me/components/viewer.dart';
import 'package:tutor_me/theme/theme.dart';

class TaskViewer extends RefreshableViewer<Task, TaskBloc> {
  final UserType _uType;
  final String? _tuteeName;
  final String _userID;
  const TaskViewer(this._uType, this._tuteeName, this._userID);

  @override
  List<Widget> process(List<Task> state, BuildContext _) => state
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
        IconButton(
            icon: Icon(Icons.add_task, color: mainTheme.accentColor),
            onPressed: () async {
              var content = await prompt(context,
                  hintText: "Homework Description", autoFocus: true);
              if (content == null) {
                return;
              }

              var tempDueDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                  helpText: "Select Due Date");
              if (tempDueDate == null) {
                return;
              }
              var tempDueTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  helpText: "Select Due Time");
              if (tempDueTime == null) {
                return;
              }

              var dueDate = DateTime(tempDueDate.year, tempDueDate.month,
                  tempDueDate.day, tempDueTime.hour, tempDueTime.minute);

              _taskBloc.add(AddTask(
                  Task(DateTime.now(), dueDate, content, false), _tuteeName!));
            }),
    ];
  }
}
