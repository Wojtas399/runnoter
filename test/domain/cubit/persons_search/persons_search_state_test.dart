import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/cubit/persons_search/persons_search_cubit.dart';

import '../../../creators/person_creator.dart';

void main() {
  late PersonsSearchState state;

  setUp(() {
    state = const PersonsSearchState(status: BlocStatusInitial());
  });

  test(
    'copy with status, '
    'should set complete status if new status is null',
    () {
      const BlocStatus expected = BlocStatusLoading();

      state = state.copyWith(status: expected);
      final state2 = state.copyWith();

      expect(state.status, expected);
      expect(state2.status, const BlocStatusComplete());
    },
  );

  test(
    'copy with search query, '
    'should copy current value if new value is null',
    () {
      const String expected = 'WOW';

      state = state.copyWith(searchQuery: expected);
      final state2 = state.copyWith();

      expect(state.searchQuery, expected);
      expect(state2.searchQuery, expected);
    },
  );

  test(
    'copy with clientIds, '
    'should copy current value if new value is null',
    () {
      const List<String> expected = ['c1', 'c2'];

      state = state.copyWith(clientIds: expected);
      final state2 = state.copyWith();

      expect(state.clientIds, expected);
      expect(state2.clientIds, expected);
    },
  );

  test(
    'copy with invitedPersonIds, '
    'should copy current value if new value is null',
    () {
      const List<String> expected = ['c1', 'c2'];

      state = state.copyWith(invitedPersonIds: expected);
      final state2 = state.copyWith();

      expect(state.invitedPersonIds, expected);
      expect(state2.invitedPersonIds, expected);
    },
  );

  test(
    'copy with foundPersons, '
    'should copy current value if new value is null',
    () {
      final List<FoundPerson> expected = [
        FoundPerson(
          info: createPerson(id: 'c1', name: 'name1', surname: 'surname1'),
          relationshipStatus: RelationshipStatus.notInvited,
        ),
        FoundPerson(
          info: createPerson(id: 'c2', name: 'name2', surname: 'surname2'),
          relationshipStatus: RelationshipStatus.accepted,
        ),
      ];

      state = state.copyWith(foundPersons: expected);
      final state2 = state.copyWith();

      expect(state.foundPersons, expected);
      expect(state2.foundPersons, expected);
    },
  );

  test(
    'copy with setFoundPersonsAsNull, '
    'should set foundPersons as null if set to true',
    () {
      final List<FoundPerson> expected = [
        FoundPerson(
          info: createPerson(id: 'c1', name: 'name1', surname: 'surname1'),
          relationshipStatus: RelationshipStatus.notInvited,
        ),
        FoundPerson(
          info: createPerson(id: 'c2', name: 'name2', surname: 'surname2'),
          relationshipStatus: RelationshipStatus.accepted,
        ),
      ];

      state = state.copyWith(foundPersons: expected);
      final state2 = state.copyWith(setFoundPersonsAsNull: true);

      expect(state.foundPersons, expected);
      expect(state2.foundPersons, null);
    },
  );
}
