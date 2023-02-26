import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
}
