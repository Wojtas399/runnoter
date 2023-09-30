import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/service/connectivity_service.dart';

class MockConnectivityService extends Mock implements ConnectivityService {
  void mockGetConnectivityStatus({
    required Stream<bool> hasDeviceInternetConnection$,
  }) {
    when(
      () => connectivityStatus$,
    ).thenAnswer((_) => hasDeviceInternetConnection$);
  }

  void mockHasDeviceInternetConnection({
    required bool hasConnection,
  }) {
    when(
      () => hasDeviceInternetConnection(),
    ).thenAnswer((invocation) => Future.value(hasConnection));
  }
}
