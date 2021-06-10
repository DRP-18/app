import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

class TuteeBloc extends Bloc<TuteeEvent, List<Tutee>> {
  final String userID;

  TuteeBloc(this.userID) : super([]);

  List<Tutee> get initialState => [];

  @override
  Stream<List<Tutee>> mapEventToState(TuteeEvent event) async* {
    yield await event.handle(userID);
  }
}

abstract class TuteeEvent {
  Future<List<Tutee>> handle(String userID);
}

class Add extends TuteeEvent {
  // final Uri url = Uri.parse("https://tutor-drp.herokuapp.com/addtutee");
  final Uri url = Uri.parse("http://192.168.1.118:8080/addtutee");
  late String _tuteeName;

  Add(String tuteeName) {
    _tuteeName = tuteeName;
  }

  @override
  Future<List<Tutee>> handle(String userID) async {
    await http.post(url, headers: {
      "Cookie": "user_id=$userID",
    }, body: {
      "tutee_name": _tuteeName,
    });
    return Refresh().handle(userID);
  }
}

class Refresh extends TuteeEvent {
  // final Uri url = Uri.parse("https://tutor-drp.herokuapp.com/viewtutees");
  final Uri url = Uri.parse("http://192.168.1.118:8080/viewtutees");

  @override
  Future<List<Tutee>> handle(String userID) async {
    var resp = await http.get(url, headers: {
      "Cookie": "user_id=$userID",
    });
    if (resp.statusCode != 200) {
      return List.empty();
    }
    var rawTutees = json.decode(utf8.decode(resp.bodyBytes));
    return _parseTutees(rawTutees);
  }

  List<Tutee> _parseTutees(List raw) {
    return raw.map((e) => _parseTutee(e as Map)).toList();
  }

  Tutee _parseTutee(Map obj) {
    return Tutee(
      obj["name"]!,
      obj["id"]!,
    );
  }
}

class Tutee {
  final String name;
  final int id;
  const Tutee(this.name, this.id);
}
