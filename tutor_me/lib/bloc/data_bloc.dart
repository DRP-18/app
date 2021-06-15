import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart';

//DataBloc represents a list of potentially refreshable data hosted on a server
//The data will be transferred as json
abstract class DataBloc<T> extends Bloc<DataEvent<T>, List<T>> {
  final List<String> _fields;

  DataBloc(this._fields) : super([]);

  List<T> get initialState => [];

  @override
  Stream<List<T>> mapEventToState(DataEvent<T> event) async* {
    yield await event.handle(_fields);
  }
}

abstract class DataEvent<T> {
  Future<List<T>> handle(List<String> fields);
}

abstract class Refresh<T> extends DataEvent<T> {
  final Function _dataConstructor;

  Refresh(this._dataConstructor);

  Future<Response> request(List<String> fields);

  @override
  Future<List<T>> handle(List<String> fields) async {
    var resp = await request(fields);
    if (resp.statusCode != 200) {
      return List.empty();
    }
    var rawData = json.decode(resp.body);
    return rawData.map((e) => _dataConstructor(e as Map)).toList();
  }
}