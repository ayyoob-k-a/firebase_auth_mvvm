import 'package:equatable/equatable.dart';

/// The Model in MVVM.
///
/// Represents the data/state for the counter feature.
/// It is a pure Dart class — no Flutter dependencies.
class CounterModel extends Equatable {
  final int count;

  const CounterModel({this.count = 0});

  CounterModel copyWith({int? count}) => CounterModel(count: count ?? this.count);

  @override
  List<Object?> get props => [count];
}
