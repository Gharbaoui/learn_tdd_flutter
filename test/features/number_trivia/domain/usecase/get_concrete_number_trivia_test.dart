import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  MockNumberTriviaRepository mockNumberTriviaRepository;
  GetConcreteNumberTrivia getConcreteNumberTrivia;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    getConcreteNumberTrivia =
        GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });
}
