import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInt(String str) {
    throw UnimplementedError();
  }
}

class InvalidInputFailure extends Failure {}
