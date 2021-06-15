import 'package:http/http.dart' as http;
import 'data_bloc.dart';

class SessionBloc extends DataBloc<Session> {
  SessionBloc(List<String> fields) : super(fields);
}

class Session {
  final String tutor;
  final List<String> tutees;
  final DateTime start;
  final Duration duration;

  const Session(this.tutor, this.tutees, this.start, this.duration);

  static Session fromJson(Map obj) {
    return Session(
        obj["tutor"]!, obj["tutees"]!, obj["start"]!, obj["duration"]!);
  }

  String toJson() {
    return """{"tutor": "$tutor", "tutees": $tutees, "date": ${start.toUtc()}, "duration": ${duration.toString()}}""";
  }
}

class AddSession extends DataEvent<Session> {
  final url = Uri.parse("https://tutor-drp.herokuapp.com/addSession");
  final _session;

  AddSession(this._session);

  @override
  Future<List<Session>> handle(List<String> fields) async {
    await http.post(url, body: _session.toJson());
    return RefreshSessions().handle(fields);
  }
}

class RemoveSession extends DataEvent<Session> {
  final url = Uri.parse("https://tutor-drp.herokuapp.com/removeSession");
  final _session;

  RemoveSession(this._session);

  @override
  Future<List<Session>> handle(List<String> fields) async {
    await http.post(url, body: _session.toJson());
    return RefreshSessions().handle(fields);
  }
}

class RefreshSessions extends Refresh<Session> {
  final url = Uri.parse("https://tutor-drp.herokuapp.com/getSessions");

  RefreshSessions() : super((e) => Session.fromJson(e));

  @override
  Future<http.Response> request(List<String> fields) {
    return http.post(url, body: {
      "tutor": fields[0],
    });
  }
}
