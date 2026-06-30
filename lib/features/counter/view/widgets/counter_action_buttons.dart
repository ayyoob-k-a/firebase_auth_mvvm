import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view_model/counter_bloc.dart';

/// FAB group that dispatches events to the [CounterBloc] ViewModel.
class CounterActionButtons extends StatelessWidget {
  const CounterActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CounterBloc>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: 'increment',
          tooltip: 'Increment',
          onPressed: () => bloc.add(const CounterIncrementPressed()),
          child: const Icon(Icons.add),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: 'decrement',
          tooltip: 'Decrement',
          onPressed: () => bloc.add(const CounterDecrementPressed()),
          child: const Icon(Icons.remove),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          heroTag: 'reset',
          tooltip: 'Reset',
          onPressed: () => bloc.add(const CounterResetPressed()),
          child: const Icon(Icons.refresh),
        ),
      ],
    );
  }
}
