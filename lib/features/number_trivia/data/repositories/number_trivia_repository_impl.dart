// repistory need a lower level data sources
// to get the actual data from them

import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/core/platform/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepsitoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const NumberTriviaRepsitoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
    int number,
  ) async {
    try {
      networkInfo.isConnected;
      final numberTriviaModel =
          await remoteDataSource.getConcreteNumberTrivia(number);
      localDataSource.cacheNumberTrivia(numberTriviaModel);
      return Right(numberTriviaModel);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return const Right(NumberTrivia(text: 'Test Text', number: 1));
  }
}
