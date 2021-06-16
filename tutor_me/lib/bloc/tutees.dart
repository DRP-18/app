import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:tutor_me/bloc/data_bloc.dart';

class TuteeBloc extends DataBloc<Tutee> {
  final String userID;

  TuteeBloc(this.userID) : super([userID]);

  @override
  Stream<List<Tutee>> mapEventToState(DataEvent<Tutee> event) async* {
    yield await event.handle([userID]);
  }
}

class Tutee {
  final String name;
  final int id;
  const Tutee(this.name, this.id);
}

class RefreshTutee extends Refresh<Tutee> {
  final Uri url = Uri.parse("https://tutor-drp.herokuapp.com/viewtutees");

  @override
  Tutee dataConstructor(Map obj) => Tutee(
        obj["name"]!,
        obj["id"]!,
      );

  @override
  Future<http.Response> request(List<String> fields) {
    final userID = fields[0];
    return http.get(url, headers: {
      "Cookie": "user_id=$userID",
    });
  }
}

class AddTutee extends DataEvent<Tutee> {
  final Uri url = Uri.parse("https://tutor-drp.herokuapp.com/addtutee");
  final String _tuteeName;

  AddTutee(this._tuteeName);

  @override
  Future<List<Tutee>> handle(List<String> fields) async {
    final userID = fields[0];
    await http.post(url, headers: {
      "Cookie": "user_id=$userID",
    }, body: {
      "tutee_name": _tuteeName,
    });
    return RefreshTutee().handle(fields);
  }
}
