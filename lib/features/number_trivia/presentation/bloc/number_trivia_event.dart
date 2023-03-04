import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();
}

class GetNumberTriviaForConcrete extends NumberTriviaEvent {
  final String numberString;

  const GetNumberTriviaForConcrete(this.numberString);

  @override
  List<Object?> get props => [numberString];
}

class GetNumberTriviaForRandom extends NumberTriviaEvent {
  const GetNumberTriviaForRandom();
  @override
  List<Object?> get props => [];
}
