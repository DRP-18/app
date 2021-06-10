import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_me/bloc/calendar.dart';
import 'package:tutor_me/theme/theme.dart';

enum UserType { Tutee, Tutor }

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
        backgroundColor: mainTheme.accentColor,
      ),
      backgroundColor: mainTheme.primaryColor,
      body: BlocProvider<CalendarBloc>(
        create: (context) => CalendarBloc(_userID),
        child: EventViewer(_uType, null),
      ),
    );
  }
}

class EventViewer extends StatelessWidget {
  final UserType _uType;
  final String? _tuteeName;
  const EventViewer(this._uType, this._tuteeName);

  @override
  Widget build(BuildContext context) {
    final CalendarBloc _calendarBloc = BlocProvider.of(context);
    return Container(
      child: BlocBuilder(
        bloc: _calendarBloc,
        builder: (context, List<Task> state) {
          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  child: ListView(
                    children: state
                        .where((e) => e.end.isAfter(DateTime.now()))
                        .map((e) => TuteeCard(e))
                        .toList(),
                  ),
                  onRefresh: () {
                    //On the off chance that someone ever looks at this again, please note that this is not the standard way
                    //But also the standard way is another hack
                    return () async {
                      var state = await Refresh(null).handle(_calendarBloc.userID);
                      _calendarBloc.emit(state);
                    }();
                  },
                ),
              ),
              if (_uType == UserType.Tutor)
                ElevatedButton(
                    onPressed: () => _calendarBloc.add(Add(Task(
                        DateTime.now(), DateTime.now(), "Got any grapes?", 1), _tuteeName!)),
                    child: Text("Add")),
            ],
          );
        },
      ),
    );
  }
}

class TuteeCard extends StatelessWidget {
  final Task _task;

  const TuteeCard(this._task, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      title: Text(_task.content),
      subtitle: Text("${_formatTime()}"),
    ));
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
  const TutorCard(this._task, this._tuteeName ,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CalendarBloc _calendarBloc = BlocProvider.of(context);
    return Card(
        child: ListTile(
      title: Text(_task.content),
      trailing: IconButton(
          onPressed: () => _calendarBloc.add(Remove(_task.id!, _tuteeName)),
          icon: Icon(Icons.cancel_outlined)),
    ));
  }
}
