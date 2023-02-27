import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';

import '../../../../core/fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient mockHttpClient = MockHttpClient();
  NumberTriviaRemoteDataSourceImpl remoteDataSource =
      NumberTriviaRemoteDataSourceImpl(mockHttpClient);

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteDataSource = NumberTriviaRemoteDataSourceImpl(mockHttpClient);
  });

  group('getConcreteNumberTrivia', () {
    const tNumber = 9;
    test(
        'should preform a GET request on a URL with number and with application/json header',
        () async {
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
      await remoteDataSource.getConcreteNumberTrivia(tNumber);
      verify(
        () => mockHttpClient.get(
          Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'},
        ),
      ).called(1);
    });
  });
}
