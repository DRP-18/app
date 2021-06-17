import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:tutor_me/bloc/session.dart';
import 'package:tutor_me/components/book_session.dart';
import 'package:tutor_me/theme/theme.dart';

class CalendarScreen extends StatelessWidget {
  final String _name;

  const CalendarScreen(this._name, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SessionBloc _sessionBloc = BlocProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sessions",
          style: textStyle.copyWith(color: mainTheme.accentColor),
        ),
      ),
      body: Container(
          child: BlocBuilder(
        bloc: _sessionBloc,
        builder: (BuildContext context, List<Session> state) =>
            RefreshIndicator(
          onRefresh: () async {
            var state = await RefreshSessions().handle([_sessionBloc.userID]);
            _sessionBloc.emit(state);
          },
          child: SfCalendar(
            view: CalendarView.week,
            dataSource: _AppointmentDataSource(
                state.map(_sessionToAppointment).toList()),
            initialSelectedDate: DateTime.now(),
            todayHighlightColor: mainTheme.primaryColor,
            selectionDecoration: BoxDecoration(
              border: Border.all(color: mainTheme.primaryColor, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              shape: BoxShape.rectangle,
            ),
            onLongPress: (CalendarLongPressDetails details) {
              showDialog(
                  context: context,
                  builder: (context) => details.appointments == null
                      ? SessionBooker(_name, _sessionBloc.userID, details.date!,
                          _sessionBloc)
                      : () {
                          final Appointment _appointment =
                              details.appointments![0];
                          return SessionRemover(
                              _sessionBloc.userID,
                              _appointment.startTime,
                              _appointment.endTime,
                              _sessionBloc);
                        }());
            },
          ),
        ),
      )),
    );
  }
}

Appointment _sessionToAppointment(Session session) => Appointment(
      startTime: session.start,
      endTime: session.end,
      subject: "${session.tutor}, ${session.tutees}",
      color: Colors.green,
    );

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
