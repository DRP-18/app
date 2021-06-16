import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_me/bloc/data_bloc.dart';

abstract class RefreshableViewer<E, T extends DataBloc<E>> extends StatelessWidget {  

  final List<Widget> _children;

  const RefreshableViewer(this._children, { Key? key }) : super(key: key);

  Future<List<E>> _refresher();

  StatelessWidget _map(E state);

  @override
  Widget build(BuildContext context) {
    final T _bloc = BlocProvider.of(context);
    return Container(
      child: BlocBuilder(
        bloc: _bloc,
        builder: (context, List<E> state) {
          return Column(
            // ignore: unnecessary_cast
            children: ([
              Expanded(
                child: RefreshIndicator(
                  child: ListView(
                    children: state.map((e) => _map(e)).toList(),
                  ),
                  onRefresh: () {
                    //On the off chance that someone ever looks at this again, please note that this is not the standard way
                    //But also the standard way is another hack
                    return () async {
                      var state = await _refresher();
                      _bloc.emit(state);
                    }();
                  },
                ),
              ),
            ] as List<Widget>) + _children,
          );
        },
      ),
    );
  }
}