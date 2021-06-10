import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_me/bloc/calendar.dart';
import 'package:tutor_me/bloc/tutees.dart';
import 'package:tutor_me/components/event_viewer.dart';
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
        backgroundColor: mainTheme.accentColor,
      ),
      backgroundColor: mainTheme.primaryColor,
      body: _uType == UserType.Tutee ? BlocProvider<CalendarBloc>(
        create: (context) => CalendarBloc(_userID, _userID),
        child: EventViewer(_uType, null, _userID),
      ) : BlocProvider<TuteeBloc>(
        create: (context) => TuteeBloc(_userID),
        child: TuteeViewer(),
      ),
    );
  }
}

