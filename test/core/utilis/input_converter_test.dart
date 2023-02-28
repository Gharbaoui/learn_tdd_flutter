import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/utils/input_converter.dart';

void main() {
  InputConverter inputConverter = InputConverter();

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
        'should return a valid unsigned integer when str is valid unsigned int',
        () {
      const str = '12345';
      final result = inputConverter.stringToUnsignedInt(str);
      expect(result, const Right(12345));
    });

    test('should return a failure when string is not int', () {
      const str = 'abc';
      final result = inputConverter.stringToUnsignedInt(str);
      expect(result, Left(InvalidInputFailure()));
    });

    test('should return a failure when string representing a negative number',
        () {
      const str = '-12345';
      final result = inputConverter.stringToUnsignedInt(str);
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
