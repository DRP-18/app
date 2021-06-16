import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_me/bloc/data_bloc.dart';

abstract class RefreshableViewer<E, T extends DataBloc<E>> extends StatelessWidget {  

  const RefreshableViewer({ Key? key }) : super(key: key);

  List<Widget> children(BuildContext context);

  Future<List<E>> refresher(BuildContext context);

  List<StatelessWidget> process(List<E> state);

  @override
  Widget build(BuildContext context) {
    final T _bloc = BlocProvider.of(context);
    return Container(
      child: BlocBuilder(
        bloc: _bloc,
        builder: (context, List<E> state) {
          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  child: ListView(
                    children: process(state),
                  ),
                  onRefresh: () {
                    //On the off chance that someone ever looks at this again, please note that this is not the standard way
                    //But also the standard way is another hack
                    return () async {
                      var state = await refresher(context);
                      _bloc.emit(state);
                    }();
                  },
                ),
              ),
            // ignore: unnecessary_cast
            ].map((e) => e as Widget).toList() + children(context),
          );
        },
      ),
    );
  }
}