import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tutor_me/bloc/session.dart';
import 'package:tutor_me/theme/theme.dart';
import 'package:http/http.dart' as http;

class SessionBooker extends StatefulWidget {
  final String _name;
  final String _userID;
  final DateTime _start;
  final SessionBloc _bloc;

  const SessionBooker(this._name, this._userID, this._start, this._bloc,
      {Key? key})
      : super(key: key);

  @override
  _SessionBookerState createState() =>
      _SessionBookerState(_name, _userID, _start, _bloc);
}

class _SessionBookerState extends State<SessionBooker> {
  final String name;
  final String _userID;
  final DateTime _start;
  final SessionBloc _bloc;

  late Future<List<String>> _tutees;

  final Uri url = Uri.parse("https://tutor-drp.herokuapp.com/viewtutees");

  var dropdownValue;

  _SessionBookerState(this.name, this._userID, this._start, this._bloc) {
    _tutees = _getTutees();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _tutees,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        return AlertDialog(
          content: Container(
            width: 200,
            height: 220,
            child: Column(children: [
              Text(
                "Book a session",
                style: textStyle.copyWith(color: mainTheme.primaryColor),
              ),
              Divider(thickness: 2),
              SizedBox(
                height: 30,
              ),
              DropdownButton<String>(
                value: dropdownValue,
                elevation: 16,
                style: textStyle.copyWith(
                    color: mainTheme.primaryColor, fontSize: 16),
                underline: Container(
                  height: 2,
                  color: mainTheme.primaryColor,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: snapshot.data!
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Container(width: 150, child: Text(value)),
                  );
                }).toList(),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(mainTheme.accentColor),
                      foregroundColor:
                          MaterialStateProperty.all(mainTheme.primaryColor),
                    ),
                  ),
                  SizedBox(width: 80),
                  OutlinedButton(
                    onPressed: () {
                      _bloc.add(AddSession(Session(
                        name,
                        dropdownValue,
                        _start,
                        _start.add(Duration(hours: 1)),
                      )));
                      Navigator.pop(context);
                    },
                    child: Text("Book"),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(mainTheme.accentColor),
                      foregroundColor:
                          MaterialStateProperty.all(mainTheme.primaryColor),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        );
      },
    );
  }

  Future<List<String>> _getTutees() async {
    var resp = await http.get(url, headers: {
      "Cookie": "user_id=$_userID",
    });
    if (resp.statusCode != 200) {
      return List.empty();
    }
    var objs = json.decode(resp.body);
    var names = objs.map<String>((e) => e["name"]! as String).toList();
    setState(() {
      dropdownValue = names[0];
    });
    return names;
  }
}

class SessionRemover extends StatelessWidget {
  final SessionBloc _bloc;
  final String userID;
  final DateTime _start;
  final DateTime _end;

  const SessionRemover(this.userID, this._start, this._end, this._bloc,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          "Are you sure you want to delete this session?\n\nThink of the children.\n\nAnakin."),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "NO",
                  style: TextStyle(color: Colors.green),
                )),
            OutlinedButton(
                onPressed: () {
                  _bloc.add(RemoveSession(
                      Session("", "", _start, _end)));
                  Navigator.pop(context);
                },
                child: Text(
                  "YES",
                  style: TextStyle(color: Colors.red),
                )),
          ],
        ),
      ],
    );
  }
}
