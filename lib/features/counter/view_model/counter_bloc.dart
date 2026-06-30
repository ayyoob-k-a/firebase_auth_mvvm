import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/counter_model.dart';

part 'counter_event.dart';
part 'counter_state.dart';

/// ViewModel in MVVM — implemented as a BLoC.
///
/// Owns and mutates the [CounterModel] in response to [CounterEvent]s,
/// then exposes the new state to the View via [CounterState].
///
/// The View never touches the Model directly.
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterInitial()) {
    on<CounterIncrementPressed>(_onIncrement);
    on<CounterDecrementPressed>(_onDecrement);
    on<CounterResetPressed>(_onReset);
  }

  void _onIncrement(CounterIncrementPressed event, Emitter<CounterState> emit) {
    emit(CounterUpdated(model: state.model.copyWith(count: state.model.count + 1)));
  }

  void _onDecrement(CounterDecrementPressed event, Emitter<CounterState> emit) {
    emit(CounterUpdated(model: state.model.copyWith(count: state.model.count - 1)));
  }

  void _onReset(CounterResetPressed event, Emitter<CounterState> emit) {
    emit(const CounterInitial());
  }
}
