import 'package:mocktail/mocktail.dart';
import 'package:runnoter/presentation/service/connectivity_service.dart';

class MockConnectivityService extends Mock implements ConnectivityService {
  void mockHasDeviceInternetConnection({
    required bool hasConnection,
  }) {
    when(
      () => hasDeviceInternetConnection(),
    ).thenAnswer((invocation) => Future.value(hasConnection));
  }
}
