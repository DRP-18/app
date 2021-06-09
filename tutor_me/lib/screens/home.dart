import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_me/bloc/calendar.dart';
import 'package:tutor_me/theme/theme.dart';

class HomeScreen extends StatelessWidget {
  final String userID;

  const HomeScreen(this.userID, {Key? key}) : super(key: key);

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
        child: EventViewer(),
      ),
    );
  }
}

class EventViewer extends StatelessWidget {
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
                child: ListView(
                  children: state.map((e) => 
                    Text(e.content)
                  ).toList(),
                ),
              ),
              ElevatedButton(
                  onPressed: () => _calendarBloc.add(
                      Add(Task(DateTime.now(), DateTime.now(), "Hello", 2))),
                  child: Text("Add")),
            ],
          );
        },
      ),
    );
  }
}
