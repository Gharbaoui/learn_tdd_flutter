import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  setUpAll(() {
    registerFallbackValue(const NumberTriviaModel(number: -1, text: 'setup'));
  });

  MockRemoteDataSource mockRemoteDataSource = MockRemoteDataSource();
  MockLocalDataSource mockLocalDataSource = MockLocalDataSource();
  MockNetworkInfo mockNetworkInfo = MockNetworkInfo();
  NumberTriviaRepsitoryImpl repository = NumberTriviaRepsitoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo);

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepsitoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockLocalDataSource.cacheNumberTrivia(any()))
            .thenAnswer((_) async {});
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(() => mockLocalDataSource.cacheNumberTrivia(any()))
            .thenAnswer((_) async {});
      });
      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    const int tNumber = 0;
    const tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'Test Text');
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('check if device online', () {
      when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
          .thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockLocalDataSource.cacheNumberTrivia(any()))
          .thenAnswer((_) async {});

      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      repository.getConcreteNumberTrivia(tNumber);
      verify(() => mockNetworkInfo.isConnected).called(1);
      verifyNoMoreInteractions(mockNetworkInfo);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is success',
          () async {
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository.getConcreteNumberTrivia(tNumber);
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .called(1);
        expect(result, const Right(tNumberTrivia));
        verifyNoMoreInteractions(mockRemoteDataSource);
      });
      test(
          'should cache the data locally when the call to remote data source is success',
          () async {
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);

        await repository.getConcreteNumberTrivia(tNumber);

        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .called(1);
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockLocalDataSource);
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
            .thenThrow(ServerException());

        final result = await repository.getConcreteNumberTrivia(tNumber);
        verify(() => (mockRemoteDataSource.getConcreteNumberTrivia(tNumber)))
            .called(1);
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, Left(ServerFailure()));
      });
    });
    runTestsOffline(() {
      test('should return last locally data when the cached data is present',
          () async {
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        final result = await repository.getConcreteNumberTrivia(tNumber);
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia()).called(1);
        expect(result, const Right(tNumberTrivia));
      });
      test('should return cache failure when there is no cached data',
          () async {
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        final result = await repository.getConcreteNumberTrivia(tNumber);
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia()).called(1);
        expect(result, Left(CacheFailure()));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(number: 34, text: 'Test Text');
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('check if device online', () {
      when(() => mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockLocalDataSource.cacheNumberTrivia(any()))
          .thenAnswer((_) async {});

      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      repository.getRandomNumberTrivia();
      verify(() => mockNetworkInfo.isConnected).called(1);
      verifyNoMoreInteractions(mockNetworkInfo);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is success',
          () async {
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository.getRandomNumberTrivia();
        verify(() => mockRemoteDataSource.getRandomNumberTrivia()).called(1);
        expect(result, const Right(tNumberTrivia));
        verifyNoMoreInteractions(mockRemoteDataSource);
      });
      test(
          'should cache the data locally when the call to remote data source is success',
          () async {
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        await repository.getRandomNumberTrivia();

        verify(() => mockRemoteDataSource.getRandomNumberTrivia()).called(1);
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
        verifyNoMoreInteractions(mockLocalDataSource);
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());

        final result = await repository.getRandomNumberTrivia();
        verify(() => (mockRemoteDataSource.getRandomNumberTrivia())).called(1);
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, Left(ServerFailure()));
      });
    });
    runTestsOffline(() {
      test('should return last locally data when the cached data is present',
          () async {
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        final result = await repository.getRandomNumberTrivia();
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia()).called(1);
        expect(result, const Right(tNumberTrivia));
      });
      test('should return cache failure when there is no cached data',
          () async {
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        final result = await repository.getRandomNumberTrivia();
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia()).called(1);
        expect(result, Left(CacheFailure()));
      });
    });
  });
}
