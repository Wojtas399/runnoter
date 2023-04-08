import 'package:mocktail/mocktail.dart';
import 'package:runnoter/presentation/service/date_service.dart';

class MockDateService extends Mock implements DateService {
  void mockGetNow({
    required DateTime now,
  }) {
    when(
      () => getNow(),
    ).thenReturn(now);
  }
}
