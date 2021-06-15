import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_me/bloc/calendar.dart';
import 'package:tutor_me/components/event_viewer.dart';
import 'package:tutor_me/components/users.dart';
import 'package:tutor_me/theme/theme.dart';

class TuteeScreen extends StatelessWidget {
  final String _name;
  final String _userID;
  final String _tuteeID;

  const TuteeScreen(this._userID, this._tuteeID, this._name, {Key? key}) : super(key: key);

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
      body: BlocProvider<CalendarBloc>(
        create: (context) => CalendarBloc(_userID, _tuteeID)..add(Refresh(_name)),
        child: EventViewer(UserType.Tutor, _name, _userID),
      )
    );
  }
}

