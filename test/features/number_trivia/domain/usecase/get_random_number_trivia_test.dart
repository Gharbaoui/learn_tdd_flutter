import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  const NumberTrivia numberTrivia = NumberTrivia(text: '', number: 1);

  MockNumberTriviaRepository repository = MockNumberTriviaRepository();
  GetRandomNumberTrivia usecase = GetRandomNumberTrivia(repository);

  setUp(() {
    repository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(repository);
  });

  test('should get random number trivia from the repository', () async {
    when(() => repository.getRandomNumberTrivia())
        .thenAnswer((_) async => const Right(numberTrivia));

    final result = await usecase(NoParams());

    expect(result, const Right(numberTrivia));

    verify(() => repository.getRandomNumberTrivia()).called(1);
    verifyNoMoreInteractions(repository);
  });
}
