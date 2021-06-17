import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'data_bloc.dart';

class SessionBloc extends DataBloc<Session> {
  final String userID;

  SessionBloc(this.userID) : super([userID]);

  @override
  Stream<List<Session>> mapEventToState(DataEvent<Session> event) async* {
    yield await event.handle(fields);
  }
}

class Session {
  final String tutor;
  final String tutees;
  final DateTime start;
  final DateTime end;

  const Session(this.tutor, this.tutees, this.start, this.end);

  static Session fromJson(Map obj) {
    final _format = DateFormat("EEE MMM dd yyyy HH:mm:ss");
    return Session(obj["tutor"]!, obj["tutees"]!,
        _format.parse(obj["startTime"]!), _format.parse(obj["endTime"]!));
  }

  String toJson(String userID) {
    final _format = DateFormat("yyyy-MM-dd'T'HH:mm");
    return """{"tutor": "$userID", "tutees": "$tutees", "startTime": "${_format.format(start)}", "endTime": "${_format.format(end)}"}""";
  }
}

class AddSession extends DataEvent<Session> {
  final url = Uri.parse("https://tutor-drp.herokuapp.com/addSession");
  final _session;

  AddSession(this._session);

  @override
  Future<List<Session>> handle(List<String> fields) async {
    final userID = fields[0];
    var resp = await http.post(url,
        headers: {
          "Content-Type": "application/json",
        },
        body: _session.toJson(userID));
    print(resp);
    return RefreshSessions().handle(fields);
  }
}

class RemoveSession extends DataEvent<Session> {
  final url = Uri.parse("https://tutor-drp.herokuapp.com/removeSession");
  final _session;

  RemoveSession(this._session);

  @override
  Future<List<Session>> handle(List<String> fields) async {
    final userID = fields[0];
    var resp = await http.post(url,
        headers: {
          "Content-Type": "application/json",
        },
        body: _session.toJson(userID));
    print(resp);
    return RefreshSessions().handle(fields);
  }
}

class RefreshSessions extends Refresh<Session> {
  final url = Uri.parse("https://tutor-drp.herokuapp.com/getSessions");

  RefreshSessions() : super();

  @override
  Future<http.Response> request(List<String> fields) {
    final String userID = fields[0];
    print(jsonEncode(<String, String>{"message": "1"}));
    return http.post(url,
        headers: {
          "Cookie": "user_id=$userID; user_type=tutor",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "message": "$userID",
        }));
  }

  @override
  Session dataConstructor(Map obj) => Session.fromJson(obj);
}
