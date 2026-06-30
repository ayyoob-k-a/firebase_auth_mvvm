part of 'counter_bloc.dart';

/// Events dispatched by the View to the ViewModel (BLoC).
abstract class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object?> get props => [];
}

/// User pressed the increment button.
class CounterIncrementPressed extends CounterEvent {
  const CounterIncrementPressed();
}

/// User pressed the decrement button.
class CounterDecrementPressed extends CounterEvent {
  const CounterDecrementPressed();
}

/// User pressed the reset button.
class CounterResetPressed extends CounterEvent {
  const CounterResetPressed();
}
