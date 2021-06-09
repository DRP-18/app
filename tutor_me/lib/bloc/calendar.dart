import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:intl/intl.dart';

class CalendarBloc extends Bloc<CalendarEvent, List<Task>> {
  final String userID;
  
  CalendarBloc(this.userID) : super([]);

  List<Task> get initialState => [];

  @override
  Stream<List<Task>> mapEventToState(CalendarEvent event) async* {
    yield await event.handle(userID);
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
  Future<List<Task>> handle(String userID);
}

class Add extends CalendarEvent {
  final _format = DateFormat("yyyy-MM-ddThh:mm");
  final Uri url = Uri.parse("https://tutor-drp.herokuapp.com/addtask");
  late Task _task;

  Add(Task task) {
    _task = task;
  }

  @override
  Future<List<Task>> handle(String userID) async {
    print(_formatTime(_task.start));
    await http.post(url, 
    headers: {
      "Cookie": "user_id=$userID",
    },
    body: {
      "start_time": _formatTime(_task.start),
      "end_time": _formatTime(_task.end),
      "content": _task.content,
      "tutee_id": _task.id.toString(),
    });
    return Refresh().handle(userID);
  }

  String _formatTime(DateTime time) {
    return _format.format(time);
  }
}

class Remove extends CalendarEvent {
  late int _id;

  Remove(int id) {
    _id = id;
  }

  @override
  Future<List<Task>> handle(String userID) async {
    return Refresh().handle(userID);
  }
}

class Refresh extends CalendarEvent {
  final url = Uri.parse("https://tutor-drp.herokuapp.com/app");
  final DateFormat format = DateFormat("E MMM dd HH:mm:ss yyyy");

  @override
  Future<List<Task>> handle(String userID) async {
    var resp = await http.get(url, headers: {"Cookie": "user_id=$userID"});
    return _parseTable(parse(resp.bodyBytes));
  }

  List<Task> _parseTable(Document doc) {
    var body = doc.getElementsByTagName("tbody");
    if (body.isEmpty) {
      return List.empty();
    }
    var rows = body[0].getElementsByTagName("tr");
    rows = rows.sublist(
        0, rows.length - 1); //Don't include last row - has action buttons
    return rows.map(_parseRow).toList();
  }

  Task _parseRow(Element row) {
    var start = _parseTime(row.children[0].innerHtml);
    var end = _parseTime(row.children[1].innerHtml);
    var content = row.children[2].innerHtml;
    var id = _getId(row.children[3]);
    return Task(start, end, content, id);
  }

  DateTime _parseTime(String timeString) {
    return format.parseUTC(timeString.replaceRange(20, 24, ""));
  }

  int _getId(Element form) {
    var button = form.getElementsByTagName("button")[0];
    return int.parse(button.attributes["value"]!);
  }
}
