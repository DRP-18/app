import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_me/bloc/tutees.dart';
import 'package:tutor_me/screens/tutee.dart';
import 'package:tutor_me/theme/theme.dart';

class TuteeViewer extends StatefulWidget {
  TuteeViewer({Key? key}) : super(key: key);

  @override
  _TuteeViewerState createState() => _TuteeViewerState();
}

class _TuteeViewerState extends State<TuteeViewer> {
  String _tuteeName = "";

  _TuteeViewerState();

  @override
  Widget build(BuildContext context) {
    final TuteeBloc _tuteeBloc = BlocProvider.of(context);
    return Container(
      child: BlocBuilder(
        bloc: _tuteeBloc,
        builder: (context, List<Tutee> state) {
          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  child: ListView(
                    children: state
                        .map((e) => Card(
                                child: ListTile(
                              title: Text(e.name),
                              trailing: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TuteeScreen(
                                                _tuteeBloc.userID,
                                                e.id.toString(),
                                                e.name)));
                                  },
                                  icon: Icon(Icons.person)),
                            )))
                        .toList(),
                  ),
                  onRefresh: () {
                    //On the off chance that someone ever looks at this again, please note that this is not the standard way
                    //But also the standard way is another hack
                    return () async {
                      var state = await Refresh().handle(_tuteeBloc.userID);
                      _tuteeBloc.emit(state);
                    }();
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Row(
                            children: [
                              Container(
                                width: 200,
                                child: TextField(
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: textStyle.copyWith(
                                      fontSize: 20,
                                      color: mainTheme.primaryColor),
                                  decoration: InputDecoration(
                                    fillColor: mainTheme.accentColor,
                                    filled: true,
                                    hintText: "Tutee Name",
                                    hintStyle: textStyle.copyWith(
                                        fontSize: 20,
                                        color: mainTheme.primaryColor),
                                  ),
                                  onChanged: (value) {
                                    _tuteeName = value;
                                  },
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    _tuteeBloc.add(Add(_tuteeName));
                                    setState(() {
                                      _tuteeName = "";
                                    });
                                  },
                                  icon: Icon(Icons.search))
                            ],
                          ),
                        );
                      });
                },
                icon: Icon(Icons.person_add),
              )
            ],
          );
        },
      ),
    );
  }
}
