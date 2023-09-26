import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/cubit/notifications/notifications_cubit.dart';

void main() {
  late NotificationsState state;

  setUp(() => state = const NotificationsState());

  test(
    'copy with idsOfClientsWithAwaitingMessages, '
    'should set new value or should copy current value if new value is null',
    () {
      const List<String> expected = ['u1', 'u2'];

      state = state.copyWith(idsOfClientsWithAwaitingMessages: expected);
      final state2 = state.copyWith();

      expect(state.idsOfClientsWithAwaitingMessages, expected);
      expect(state2.idsOfClientsWithAwaitingMessages, expected);
    },
  );

  test(
    'copy with areThereUnreadMessagesFromCoach, '
    'should set new value or should copy current value if new value is null',
    () {
      const bool expected = true;

      state = state.copyWith(areThereUnreadMessagesFromCoach: expected);
      final state2 = state.copyWith();

      expect(state.areThereUnreadMessagesFromCoach, expected);
      expect(state2.areThereUnreadMessagesFromCoach, expected);
    },
  );

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

  test(
    'copy with numberOfCoachingRequestsReceivedFromCoaches, '
    'should set new value or should copy current value if new value is null',
    () {
      const int expected = 5;

      state = state.copyWith(
        numberOfCoachingRequestsReceivedFromCoaches: expected,
      );
      final state2 = state.copyWith();

      expect(state.numberOfCoachingRequestsReceivedFromCoaches, expected);
      expect(state2.numberOfCoachingRequestsReceivedFromCoaches, expected);
    },
  );
}
