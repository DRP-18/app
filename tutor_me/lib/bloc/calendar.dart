import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarBloc extends Bloc<CalendarEvent, List<Task>> {
  CalendarBloc(List<Task> initialState) : super(initialState);

  List<Task> _state = List.empty();

  List<Task> get initialState => _state;


  @override
  Stream<List<Task>> mapEventToState(CalendarEvent event) async* {
    yield event.handle(_state);
  }

}

class Task{

}

abstract class CalendarEvent {
  List<Task> handle(List<Task> state);
}

class Add extends CalendarEvent {
  @override
  List<Task> handle(List<Task> state) {
    return state;
  }
}

class Remove extends CalendarEvent {
  @override
  List<Task> handle(List<Task> state) {
    return state;
  }
}

class Refresh extends CalendarEvent {
  @override
  List<Task> handle(List<Task> state) {
    return state;
  }
}