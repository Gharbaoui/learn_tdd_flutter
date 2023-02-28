import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

@immutable
abstract class NumberTriviaState extends Equatable {}

class EmptyNumberTriviaState extends NumberTriviaState {
  @override
  List<Object?> get props => [];
}

class LoadingNumberTriviaState extends NumberTriviaState {
  @override
  List<Object?> get props => [];
}

class LoadedNumberTriviaState extends NumberTriviaState {
  final NumberTrivia numberTrivia;

  LoadedNumberTriviaState({required this.numberTrivia});

  @override
  List<Object?> get props => [numberTrivia];
}

class ErrorNumberTriviaState extends NumberTriviaState {
  final String errorMessage;

  ErrorNumberTriviaState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
