import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_me/bloc/task.dart';
import 'package:tutor_me/screens/files.dart';

enum UserType { Tutee, Tutor }

class TuteeCard extends StatelessWidget {
  final Task _task;

  const TuteeCard(this._task, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TaskBloc _taskBloc = BlocProvider.of(context);
    final _overdue = !_task.end.isAfter(DateTime.now());
    return Card(
      child: ListTile(
        title: Text(_task.content),
        subtitle: !_overdue ? Text("${_formatTime()}") : null,
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FileScreen(_task.content, _task.id.toString(), _taskBloc.userID))),
        trailing: IconButton(
          onPressed: () {
            if (!_task.done && !_overdue) {
              _taskBloc.add(DoneTask(_task.id!.toInt()));
            }
          },
          icon: !_overdue
              ? Icon(
                  _task.done
                      ? Icons.check_box_outlined
                      : Icons.check_box_outline_blank_rounded,
                  color: _task.done ? Colors.green : Colors.red)
              : Icon(
                  Icons.access_alarms_outlined,
                  color: Colors.red,
                ),
        ),
      ),
    );
  }

  //Will return the time until the due time, formatted in the following ways:
  //1. n days m hours if more than 1 day is needed - hours omitted if 0
  //2. n hours m minutes if more than 1 hour is needed - minutes omitted if 0
  //3. n minutes
  //4. now
  String _formatTime() {
    var difference = _task.end.difference(DateTime.now());
    if (difference.inDays > 0) {
      return "Due in: " +
          _formatQuantity("day", difference.inDays) +
          _formatQuantity("hour", difference.inHours % 24);
    } else if (difference.inHours > 0) {
      return "Due in: " +
          _formatQuantity("hour", difference.inHours) +
          _formatQuantity("minute", difference.inMinutes % 60);
    } else if (difference.inMinutes > 0) {
      return "Due in: " + _formatQuantity("minute", difference.inMinutes);
    }
    return "Due now";
  }

  String _formatQuantity(String name, int value) {
    return value != 0 ? "$value $name${value > 1 ? 's ' : ' '}" : "";
  }
}

class TutorCard extends StatelessWidget {
  final Task _task;
  final String _tuteeName;
  const TutorCard(this._task, this._tuteeName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TaskBloc _taskBloc = BlocProvider.of(context);
    return Card(
        child: ListTile(
      title: Text(_task.content),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FileScreen(_task.content, _task.id.toString(), _taskBloc.userID))),
      trailing: IconButton(
          onPressed: () => _taskBloc.add(RemoveTask(_task.id!, _tuteeName)),
          icon: Icon(Icons.cancel_outlined, color: Colors.red)),
    ));
  }
}
