import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/coaching_request_short.dart';
import 'package:runnoter/domain/cubit/notifications/notifications_cubit.dart';

import '../../../creators/person_creator.dart';

void main() {
  late NotificationsState state;

  setUp(() => state = const NotificationsState());

  test(
    'copy with acceptedClientRequests, '
    'should set new value or should set empty array if new value is null',
    () {
      final List<CoachingRequestShort> expected = [
        CoachingRequestShort(
          id: 'cr1',
          personToDisplay: createPerson(id: 'p1'),
        ),
        CoachingRequestShort(
          id: 'cr2',
          personToDisplay: createPerson(id: 'p2'),
        ),
      ];

      state = state.copyWith(acceptedClientRequests: expected);
      final state2 = state.copyWith();

      expect(state.acceptedClientRequests, expected);
      expect(state2.acceptedClientRequests, const []);
    },
  );

  test(
    'copy with acceptedCoachReq, '
    'should set new value or should set null if new value is null',
    () {
      final CoachingRequestShort expected = CoachingRequestShort(
        id: 'cr1',
        personToDisplay: createPerson(id: 'p1'),
      );

      state = state.copyWith(acceptedCoachRequest: expected);
      final state2 = state.copyWith();

      expect(state.acceptedCoachRequest, expected);
      expect(state2.acceptedCoachRequest, null);
    },
  );

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
    'copy with numberOfCoachingReqsFromClients, '
    'should set new value or should copy current value if new value is null',
    () {
      const int expected = 5;

      state = state.copyWith(
        numberOfCoachingRequestsFromClients: expected,
      );
      final state2 = state.copyWith();

      expect(state.numberOfCoachingRequestsFromClients, expected);
      expect(state2.numberOfCoachingRequestsFromClients, expected);
    },
  );

  test(
    'copy with numberOfCoachingReqsFromCoaches, '
    'should set new value or should copy current value if new value is null',
    () {
      const int expected = 5;

      state = state.copyWith(
        numberOfCoachingRequestsFromCoaches: expected,
      );
      final state2 = state.copyWith();

      expect(state.numberOfCoachingRequestsFromCoaches, expected);
      expect(state2.numberOfCoachingRequestsFromCoaches, expected);
    },
  );
}
