import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/utils/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late MockGetConcreteNumberTrivia concrete;
  late MockGetRandomNumberTrivia random;
  late MockInputConverter inputConverter;
  late NumberTriviaBloc numberTriviaBloc;

  setUp(() {
    concrete = MockGetConcreteNumberTrivia();
    random = MockGetRandomNumberTrivia();
    inputConverter = MockInputConverter();
    numberTriviaBloc = NumberTriviaBloc(
      getConcreteNumberTrivia: concrete,
      getRandomNumberTrivia: random,
      inputConverter: inputConverter,
    );
  });

  test('initialState should be empty', () {
    expect(numberTriviaBloc.state, EmptyNumberTriviaState());
  });

  group('GetTriviaForConcteteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;

    blocTest(
        'input converter should be called in order to validate the string number',
        setUp: () {
          when(() => inputConverter.stringToUnsignedInt(any()))
              .thenReturn(const Right(tNumberParsed));
        },
        build: () => numberTriviaBloc,
        act: (bloc) =>
            bloc.add(const GetNumberTriviaForConcrete(tNumberString)),
        verify: (_) {
          verify(() => inputConverter.stringToUnsignedInt(tNumberString))
              .called(1);
        });
  });
}
