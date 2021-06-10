import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_me/bloc/calendar.dart';
import 'package:tutor_me/components/users.dart';

class EventViewer extends StatelessWidget {
  final UserType _uType;
  final String? _tuteeName;
  final String _userID;
  const EventViewer(this._uType, this._tuteeName, this._userID);

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
                        .map((e) => _uType == UserType.Tutee ? TuteeCard(e) : TutorCard(e, _tuteeName!))
                        .toList(),
                  ),
                  onRefresh: () {
                    //On the off chance that someone ever looks at this again, please note that this is not the standard way
                    //But also the standard way is another hack
                    return () async {
                      var state = await Refresh(null)
                          .handle(this._userID, _calendarBloc.tuteeID);
                      _calendarBloc.emit(state);
                    }();
                  },
                ),
              ),
              if (_uType == UserType.Tutor)
                ElevatedButton(
                    onPressed: () {
                      _calendarBloc.add(Add(
                          Task(DateTime.now(), DateTime.now().add(Duration(days: 1)),
                              "Homework 1"),
                          _tuteeName!));
                    },
                    child: Text("Add")),
            ],
          );
        },
      ),
    );
  }
}
