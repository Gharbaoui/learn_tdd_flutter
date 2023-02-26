import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences mockSharedPreferences = MockSharedPreferences();
  NumberTriviaLocalDataSourceImpl numberTriviaLocalDataSource =
      NumberTriviaLocalDataSourceImpl(mockSharedPreferences);

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    numberTriviaLocalDataSource =
        NumberTriviaLocalDataSourceImpl(mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    const jsonFileName = 'trivia_cached.json';
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture(jsonFileName)));
    test(
        'should return NumberTriviaModel from sharedpreference when there is one in the cache',
        () async {
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(fixture(jsonFileName));

      final result = await numberTriviaLocalDataSource.getLastNumberTrivia();
      verify(() => mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA))
          .called(1);
      expect(result, tNumberTriviaModel);
    });

    test('should throw cache exception if no value is stored', () {
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);

      final call = numberTriviaLocalDataSource.getLastNumberTrivia;
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'cache test');

    test('shared preferences should be called with the right data', () {
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) async => true);
      numberTriviaLocalDataSource.cacheNumberTrivia(tNumberTriviaModel);

      final expStr = json.encode(tNumberTriviaModel.toJson());
      verify(
          () => mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, expStr));
    });
  });
}
