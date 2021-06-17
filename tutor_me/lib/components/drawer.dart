import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_me/bloc/session.dart';
import 'package:tutor_me/screens/calendar.dart';
import 'package:tutor_me/screens/messaging.dart';
import 'package:tutor_me/theme/theme.dart';

class MainDrawer extends StatelessWidget {
  final String _userID;
  final String _name;

  const MainDrawer(
    this._userID,
    this._name, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Center(
                child: Text(
              "TUTOR ME",
              style: textStyle.copyWith(fontSize: 45),
              textAlign: TextAlign.center,
            )),
            decoration: BoxDecoration(
              color: mainTheme.primaryColor,
            ),
          ),
          ListTile(
            title: Text(
              "Chats",
              style: textStyle.copyWith(color: mainTheme.primaryColor),
              textScaleFactor: 0.8,
              textAlign: TextAlign.center,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MessagingScreenWidget(_name)));
            },
          ),
          ListTile(
            title: Text(
              "Calendar",
              style: textStyle.copyWith(color: mainTheme.primaryColor),
              textScaleFactor: 0.8,
              textAlign: TextAlign.center,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BlocProvider<SessionBloc>(
                          create: (context) =>
                              SessionBloc(_userID)..add(RefreshSessions()),
                          child: CalendarScreen(_name))));
            },
          ),
        ],
      ),
    );
  }
}
