import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_me/bloc/calendar.dart';
import 'package:tutor_me/theme/theme.dart';

enum UserType {Tutee, Tutor}
class HomeScreen extends StatelessWidget {
  final String userID;
  final UserType uType;

  const HomeScreen(this.userID, this.uType, {Key? key}) : super(key: key);

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
        create: (context) => CalendarBloc(userID),
        child: EventViewer(uType),
      ),
    );
  }
}

class EventViewer extends StatelessWidget {

  final UserType uType;
  const EventViewer(this.uType);

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
                        .map((e) => Card(
                                child: ListTile(
                              title: Text(e.content),
                              trailing: (uType == UserType.Tutor) ? IconButton(
                                  onPressed: () =>
                                      _calendarBloc.add(Remove(e.id!)),
                                  icon: Icon(Icons.cancel_outlined)) : null,
                            )))
                        .toList(),
                  ),
                  onRefresh: () {
                    //On the off chance that someone ever looks at this again, please note that this is not the standard way
                    //But also the standard way is another hack
                    return () async {
                      var state = await Refresh().handle(_calendarBloc.userID);
                      _calendarBloc.emit(state);
                    }();
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () => _calendarBloc.add(
                      Add(Task(DateTime.now(), DateTime.now(), "Got any grapes?", 1))),
                  child: Text("Add")),
            ],
          );
        },
      ),
    );
  }
}
