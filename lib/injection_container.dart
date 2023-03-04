import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/core/utils/input_converter.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final serviceLocator = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  //* Bloc
  serviceLocator.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: serviceLocator(),
      getRandomNumberTrivia: serviceLocator(),
      inputConverter: serviceLocator(),
    ),
  );
  //* use cases
  serviceLocator.registerLazySingleton(
    () => GetConcreteNumberTrivia(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetRandomNumberTrivia(serviceLocator()),
  );

  //* Repository
  serviceLocator.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepsitoryImpl(
      localDataSource: serviceLocator(),
      remoteDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );

  //* Data sources
  serviceLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(serviceLocator()),
  );

  //! Core
  serviceLocator.registerLazySingleton(
    () => InputConverter(),
  );

  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(serviceLocator()),
  );

  //! External

  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerFactory(() => Connectivity());
}
