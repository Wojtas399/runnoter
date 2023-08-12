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
    'copy with invitedPersons',
    () {
      final List<InvitedPerson> expectedInvitedPersons = [
        InvitedPerson(coachingRequestId: 'r1', person: createPerson(id: 'p1')),
        InvitedPerson(coachingRequestId: 'r2', person: createPerson(id: 'p2')),
      ];

      state = state.copyWith(invitedPersons: expectedInvitedPersons);
      final state2 = state.copyWith();

      expect(state.invitedPersons, expectedInvitedPersons);
      expect(state2.invitedPersons, expectedInvitedPersons);
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
