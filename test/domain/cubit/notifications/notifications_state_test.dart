import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/cubit/notifications/notifications_cubit.dart';

void main() {
  late NotificationsState state;

  setUp(() => state = const NotificationsState());

  test(
    'copy with numberOfCoachingRequestsReceivedFromClients, '
    'should set new value or should copy current value if new value is null',
    () {
      const int expected = 5;

      state = state.copyWith(
        numberOfCoachingRequestsReceivedFromClients: expected,
      );
      final state2 = state.copyWith();

      expect(state.numberOfCoachingRequestsReceivedFromClients, expected);
      expect(state2.numberOfCoachingRequestsReceivedFromClients, expected);
    },
  );
}
