import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  MockNumberTriviaRepository mockNumberTriviaRepository = MockNumberTriviaRepository();
  GetConcreteNumberTrivia getConcreteNumberTrivia(mockNumberTriviaRepository);

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    getConcreteNumberTrivia = mockNumberTriviaRepository;
  });
}
