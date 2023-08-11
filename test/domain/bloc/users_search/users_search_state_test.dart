import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/users_search/users_search_bloc.dart';
import 'package:runnoter/domain/entity/person.dart';
import 'package:runnoter/domain/entity/user.dart';

void main() {
  late UsersSearchState state;

  setUp(() {
    state = const UsersSearchState(
      status: BlocStatusInitial(),
      clientIds: [],
      invitedPersonIds: [],
    );
  });

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
    'copy with search query',
    () {
      const String expectedSearchQuery = 'WOW';

      state = state.copyWith(searchQuery: expectedSearchQuery);
      final state2 = state.copyWith();

      expect(state.searchQuery, expectedSearchQuery);
      expect(state2.searchQuery, expectedSearchQuery);
    },
  );

  test(
    'copy with clientIds',
    () {
      const List<String> expectedClientIds = ['c1', 'c2'];

      state = state.copyWith(clientIds: expectedClientIds);
      final state2 = state.copyWith();

      expect(state.clientIds, expectedClientIds);
      expect(state2.clientIds, expectedClientIds);
    },
  );

  test(
    'copy with invitedPersonIds',
    () {
      const List<String> expectedInvitedPersonIds = ['c1', 'c2'];

      state = state.copyWith(invitedPersonIds: expectedInvitedPersonIds);
      final state2 = state.copyWith();

      expect(state.invitedPersonIds, expectedInvitedPersonIds);
      expect(state2.invitedPersonIds, expectedInvitedPersonIds);
    },
  );

  test(
    'copy with foundPersons',
    () {
      const List<FoundPerson> expectedFoundPersons = [
        FoundPerson(
          info: Person(
            id: 'c1',
            gender: Gender.male,
            name: 'name1',
            surname: 'surname1',
            email: 'email1@example.com',
          ),
          relationshipStatus: RelationshipStatus.notInvited,
        ),
        FoundPerson(
          info: Person(
            id: 'c2',
            gender: Gender.female,
            name: 'name2',
            surname: 'surname2',
            email: 'email2@example.com',
          ),
          relationshipStatus: RelationshipStatus.accepted,
        ),
      ];

      state = state.copyWith(foundPersons: expectedFoundPersons);
      final state2 = state.copyWith();

      expect(state.foundPersons, expectedFoundPersons);
      expect(state2.foundPersons, expectedFoundPersons);
    },
  );

  test(
    'copy with setFoundPersonsAsNull',
    () {
      const List<FoundPerson> expectedFoundPersons = [
        FoundPerson(
          info: Person(
            id: 'c1',
            gender: Gender.male,
            name: 'name1',
            surname: 'surname1',
            email: 'email1@example.com',
          ),
          relationshipStatus: RelationshipStatus.notInvited,
        ),
        FoundPerson(
          info: Person(
            id: 'c2',
            gender: Gender.female,
            name: 'name2',
            surname: 'surname2',
            email: 'email2@example.com',
          ),
          relationshipStatus: RelationshipStatus.accepted,
        ),
      ];

      state = state.copyWith(foundPersons: expectedFoundPersons);
      final state2 = state.copyWith(setFoundPersonsAsNull: true);

      expect(state.foundPersons, expectedFoundPersons);
      expect(state2.foundPersons, null);
    },
  );
}
