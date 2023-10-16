import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/entity/person.dart';
import 'package:runnoter/domain/additional_model/coaching_request_with_person.dart';
import 'package:runnoter/domain/additional_model/cubit_status.dart';
import 'package:runnoter/ui/cubit/clients/clients_cubit.dart';

import '../../../creators/person_creator.dart';

void main() {
  late ClientsState state;

  setUp(
    () => state = const ClientsState(status: CubitStatusInitial()),
  );

  test(
    'copy with status, '
    'should assign complete status if new value has not been passed',
    () {
      const CubitStatus expected = CubitStatusLoading();

      state = state.copyWith(status: expected);
      final state2 = state.copyWith();

      expect(state.status, expected);
      expect(state2.status, const CubitStatusComplete());
    },
  );

  test(
    'copy with sentRequests, '
    'should copy current value if new value has not been passed',
    () {
      final List<CoachingRequestWithPerson> expected = [
        CoachingRequestWithPerson(
          id: 'r1',
          person: createPerson(id: 'p1'),
        ),
        CoachingRequestWithPerson(
          id: 'r2',
          person: createPerson(id: 'p2'),
        ),
      ];

      state = state.copyWith(sentRequests: expected);
      final state2 = state.copyWith();

      expect(state.sentRequests, expected);
      expect(state2.sentRequests, expected);
    },
  );

  test(
    'copy with receivedRequests, '
    'should copy current value if new value has not been passed',
    () {
      final List<CoachingRequestWithPerson> expected = [
        CoachingRequestWithPerson(
          id: 'r1',
          person: createPerson(id: 'p1'),
        ),
        CoachingRequestWithPerson(
          id: 'r2',
          person: createPerson(id: 'p2'),
        ),
      ];

      state = state.copyWith(receivedRequests: expected);
      final state2 = state.copyWith();

      expect(state.receivedRequests, expected);
      expect(state2.receivedRequests, expected);
    },
  );

  test(
    'copy with clients, '
    'should copy current value if new value has not been passed',
    () {
      final List<Person> expected = [
        createPerson(id: 'p1'),
        createPerson(id: 'p2'),
      ];

      state = state.copyWith(clients: expected);
      final state2 = state.copyWith();

      expect(state.clients, expected);
      expect(state2.clients, expected);
    },
  );

  test(
    'copy with selectedChatId, '
    'should assign null if new value has not been passed',
    () {
      const String expected = 'c1';

      state = state.copyWith(selectedChatId: expected);
      final state2 = state.copyWith();

      expect(state.selectedChatId, expected);
      expect(state2.selectedChatId, null);
    },
  );
}
