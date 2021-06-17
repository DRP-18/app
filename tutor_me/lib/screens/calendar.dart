import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:tutor_me/theme/theme.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sessions",
          style: textStyle.copyWith(color: mainTheme.accentColor),
        ),
      ),
      body: Container(
          child: RefreshIndicator(
        onRefresh: () async {},
        child: SfCalendar(
          view: CalendarView.month,
          dataSource: _getCalendarDataSource(),
          monthViewSettings: MonthViewSettings(
            showAgenda: true
          ),
          scheduleViewSettings: ScheduleViewSettings(
            appointmentItemHeight: 70,
            hideEmptyScheduleWeek: true,
          ),
          initialSelectedDate: DateTime.now(),
          todayHighlightColor: mainTheme.primaryColor,
          selectionDecoration: BoxDecoration(
            border: Border.all(color: mainTheme.primaryColor, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            shape: BoxShape.rectangle,
          ),
        ),
      )),
    );
  }


  _AppointmentDataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];
    appointments.add(Appointment(
      startTime: DateTime.now(),
      endTime: DateTime.now().add(Duration(minutes: 10)),
      subject: 'Mika',
      color: Colors.blue,
      startTimeZone: '',
      endTimeZone: '',
    ));

    return _AppointmentDataSource(appointments);
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
