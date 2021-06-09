import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarBloc extends Bloc<CalendarEvent, List<Task>> {
  CalendarBloc(List<Task> initialState) : super(initialState);

  final List<Task> _currentState = List.empty();

  List<Task> get initialState => _currentState;

  @override
  Stream<List<Task>> mapEventToState(CalendarEvent event) async* {
      yield event.handle(_currentState);
  }
}

class Task {
  late int? id;
  late DateTime start;
  late DateTime end;
  late String content;

  Task(DateTime start, DateTime end, String content, [int? id]) {
    this.start = start;
    this.end = end;
    this.content = content;
    this.id = id;
  }
}

abstract class CalendarEvent {
  List<Task> handle(List<Task> state);
}

class Add extends CalendarEvent {
  late Task _task;

  Add(Task task) {
    _task = task;
  }

  @override
  List<Task> handle(List<Task> state) {
    state.add(_task);
    return state;
  }
}

class Remove extends CalendarEvent {

  late int _id;

  Remove(int id) {
    _id = id;
  }

  @override
  List<Task> handle(List<Task> state) {
    state.removeWhere((element) => element.id == _id);
    return state;
  }
}

class Refresh extends CalendarEvent {
  @override
  List<Task> handle(List<Task> state) {
    return state;
  }
}
