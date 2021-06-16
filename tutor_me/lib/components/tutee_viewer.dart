import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_me/bloc/tutees.dart';
import 'package:tutor_me/components/viewer.dart';
import 'package:tutor_me/screens/tutee.dart';
import 'package:tutor_me/theme/theme.dart';

class TuteeViewer extends RefreshableViewer<Tutee, TuteeBloc> {
  @override
  List<Widget> children(BuildContext context) {
    final TuteeBloc _tuteeBloc = BlocProvider.of(context);
    return [
      IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddTuteeDialog(_tuteeBloc);
              });
        },
        icon: Icon(Icons.person_add, color: mainTheme.accentColor),
      )
    ];
  }

  @override
  List<Widget> process(List<Tutee> state, BuildContext context) {
    final TuteeBloc _tuteeBloc = BlocProvider.of(context);
    return state
        .map((e) => Card(
                child: ListTile(
              title: Text(e.name),
              trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TuteeScreen(
                                _tuteeBloc.userID, e.id.toString(), e.name)));
                  },
                  icon: Icon(Icons.person, color: mainTheme.primaryColor)),
            )))
        .toList();
  }

  @override
  Future<List<Tutee>> refresher(BuildContext context) {
    final TuteeBloc _tuteeBloc = BlocProvider.of(context);
    return RefreshTutee().handle([_tuteeBloc.userID]);
  }
}

class AddTuteeDialog extends StatefulWidget {
  final TuteeBloc _tuteeBloc;

  const AddTuteeDialog(this._tuteeBloc, {Key? key}) : super(key: key);

  @override
  _AddTuteeDialogState createState() => _AddTuteeDialogState(_tuteeBloc);
}

class _AddTuteeDialogState extends State<AddTuteeDialog> {
  String _tuteeName = "";
  final TuteeBloc _tuteeBloc;

  _AddTuteeDialogState(this._tuteeBloc);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        children: [
          Container(
            width: 200,
            child: TextField(
              maxLines: 1,
              textAlign: TextAlign.center,
              style: textStyle.copyWith(
                  fontSize: 20, color: mainTheme.primaryColor),
              decoration: InputDecoration(
                fillColor: mainTheme.accentColor,
                filled: true,
                hintText: "Tutee Name",
                hintStyle: textStyle.copyWith(
                    fontSize: 20, color: mainTheme.primaryColor),
              ),
              onChanged: (value) {
                _tuteeName = value;
              },
            ),
          ),
          IconButton(
              onPressed: () {
                _tuteeBloc.add(AddTutee(_tuteeName));
                setState(() {
                  _tuteeName = "";
                });
              },
              icon: Icon(
                Icons.add_circle_outline_sharp,
                color: mainTheme.primaryColor,
              ))
        ],
      ),
    );
  }
}
