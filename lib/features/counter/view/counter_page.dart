import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_model/counter_bloc.dart';
import 'widgets/counter_action_buttons.dart';
import 'widgets/counter_display.dart';

/// View in MVVM — Counter feature page.
///
/// Responsibilities:
///   • Provide the [CounterBloc] (ViewModel) to the widget tree.
///   • Dispatch events to the BLoC on user interaction.
///   • Rebuild from [CounterState] via [BlocBuilder] / [BlocListener].
///
/// No business logic lives here.
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  static const routeName = '/counter';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterBloc(),
      child: const _CounterView(),
    );
  }
}

class _CounterView extends StatelessWidget {
  const _CounterView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter — MVVM + BLoC'),
        centerTitle: true,
      ),
      body: const Center(child: CounterDisplay()),
      floatingActionButton: const CounterActionButtons(),
    );
  }
}
