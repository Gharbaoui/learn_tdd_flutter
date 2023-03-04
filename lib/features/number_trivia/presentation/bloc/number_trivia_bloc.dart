import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/utils/input_converter.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_event.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_state.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHE_FAILURE_MESSAGE = 'Cache Failure';
const INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - the number should be >= 0';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(EmptyNumberTriviaState()) {
    on<GetNumberTriviaForConcrete>((event, emit) {
      final converterResult =
          inputConverter.stringToUnsignedInt(event.numberString);

      converterResult.fold(
        (failure) {
          emit(ErrorNumberTriviaState(
              errorMessage: INVALID_INPUT_FAILURE_MESSAGE));
        },
        (number) async {
          emit(LoadingNumberTriviaState());
          final failureOrNumberTrivia =
              await getConcreteNumberTrivia(Params(number: number));
          failureOrNumberTrivia.fold(
            (failure) {
              emit(ErrorNumberTriviaState(
                errorMessage: _mapFailureToMessage(failure),
              ));
            },
            (numberTrivia) {
              emit(LoadedNumberTriviaState(numberTrivia: numberTrivia));
            },
          );
        },
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      default:
        return 'Unkown Error';
    }
  }
}
