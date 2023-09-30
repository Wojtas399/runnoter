import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/service/connectivity_service.dart';

class MockConnectivityService extends Mock implements ConnectivityService {
  void mockOnConnectivityStatusChanged({
    required Stream<bool> hasDeviceInternetConnection$,
  }) {
    when(
      () => onConnectivityStatusChanged(),
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
