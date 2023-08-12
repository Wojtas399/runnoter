import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/clients/clients_bloc.dart';
import 'package:runnoter/domain/entity/person.dart';

import '../../../creators/person_creator.dart';

void main() {
  late ClientsState state;

  setUp(
    () => state = const ClientsState(status: BlocStatusInitial()),
  );

  test(
    'copy with status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusComplete());
    },
  );

  test(
    'copy with sentRequests',
    () {
      final List<SentCoachingRequest> expectedSentRequests = [
        SentCoachingRequest(requestId: 'r1', receiver: createPerson(id: 'p1')),
        SentCoachingRequest(requestId: 'r2', receiver: createPerson(id: 'p2')),
      ];

      state = state.copyWith(sentRequests: expectedSentRequests);
      final state2 = state.copyWith();

      expect(state.sentRequests, expectedSentRequests);
      expect(state2.sentRequests, expectedSentRequests);
    },
  );

  test(
    'copy with clients',
    () {
      final List<Person> expectedClients = [
        createPerson(id: 'p1'),
        createPerson(id: 'p2'),
      ];

      state = state.copyWith(clients: expectedClients);
      final state2 = state.copyWith();

      expect(state.clients, expectedClients);
      expect(state2.clients, expectedClients);
    },
  );
}
