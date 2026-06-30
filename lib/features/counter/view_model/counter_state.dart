part of 'counter_bloc.dart';

/// States emitted by the ViewModel (BLoC) to the View.
abstract class CounterState extends Equatable {
  final CounterModel model;
  const CounterState({required this.model});

  @override
  List<Object?> get props => [model];
}

/// Initial state before any interaction.
class CounterInitial extends CounterState {
  const CounterInitial() : super(model: const CounterModel());
}

/// State carrying the up-to-date counter model.
class CounterUpdated extends CounterState {
  const CounterUpdated({required super.model});
}
