import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/network/network_info.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  MockConnectivity mockConnectivity = MockConnectivity();

  NetworkInfoImpl networkInfo = NetworkInfoImpl(mockConnectivity);

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfo = NetworkInfoImpl(mockConnectivity);
  });

  group('isConnected', () {
    test('should return true if we are connected to throgh mobile data',
        () async {
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.mobile);
      final result = await networkInfo.isConnected;

      verify(() => mockConnectivity.checkConnectivity()).called(1);
      expect(result, true);
    });

    test('should return true if we are connected through wifi', () async {
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.wifi);
      final result = await networkInfo.isConnected;

      verify(() => mockConnectivity.checkConnectivity()).called(1);
      expect(result, true);
    });

    test('other than wifi or mobile we should return false', () async {
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.none);

      final result = await networkInfo.isConnected;

      verify(() => mockConnectivity.checkConnectivity()).called(1);
      expect(result, false);
    });
  });
}
