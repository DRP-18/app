import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_me/bloc/files.dart';

class FileScreen extends StatelessWidget {
  final String _taskID;

  const FileScreen(this._taskID, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FileBloc _fileBloc = FileBloc(_taskID);
    return Container(
      child: BlocBuilder(
        bloc: _fileBloc,
        builder: (context, List<File> state) {
          return Column(children: [
            Expanded(
              child: RefreshIndicator(
                child: ListView(
                  children: [Card(
                    color: Colors.brown,
                    child: Text("hello"),
                    )],
                ),
                onRefresh: () {
                  //On the off chance that someone ever looks at this again, please note that this is not the standard way
                  //But also the standard way is another hack
                  return () async {
                    var state = await RefreshFile().handle([_taskID]);
                    _fileBloc.emit(state);
                  }();
                },
              ),
            ),
          ]);
        },
      ),
    );
  }
}
