import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/users_search/users_search_bloc.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/entity/user_basic_info.dart';

void main() {
  late UsersSearchState state;

  setUp(() {
    state = const UsersSearchState(
      status: BlocStatusInitial(),
      clientIds: [],
      invitedUserIds: [],
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
    'copy with invitedUserIds',
    () {
      const List<String> expectedInvitedUserIds = ['c1', 'c2'];

      state = state.copyWith(invitedUserIds: expectedInvitedUserIds);
      final state2 = state.copyWith();

      expect(state.invitedUserIds, expectedInvitedUserIds);
      expect(state2.invitedUserIds, expectedInvitedUserIds);
    },
  );

  test(
    'copy with found users',
    () {
      const List<FoundUser> expectedFoundUsers = [
        FoundUser(
          info: UserBasicInfo(
            id: 'c1',
            gender: Gender.male,
            name: 'name1',
            surname: 'surname1',
            email: 'email1@example.com',
          ),
          relationshipStatus: RelationshipStatus.notInvited,
        ),
        FoundUser(
          info: UserBasicInfo(
            id: 'c2',
            gender: Gender.female,
            name: 'name2',
            surname: 'surname2',
            email: 'email2@example.com',
          ),
          relationshipStatus: RelationshipStatus.accepted,
        ),
      ];

      state = state.copyWith(foundUsers: expectedFoundUsers);
      final state2 = state.copyWith();

      expect(state.foundUsers, expectedFoundUsers);
      expect(state2.foundUsers, expectedFoundUsers);
    },
  );

  test(
    'copy with set found users as null',
    () {
      const List<FoundUser> expectedFoundUsers = [
        FoundUser(
          info: UserBasicInfo(
            id: 'c1',
            gender: Gender.male,
            name: 'name1',
            surname: 'surname1',
            email: 'email1@example.com',
          ),
          relationshipStatus: RelationshipStatus.notInvited,
        ),
        FoundUser(
          info: UserBasicInfo(
            id: 'c2',
            gender: Gender.female,
            name: 'name2',
            surname: 'surname2',
            email: 'email2@example.com',
          ),
          relationshipStatus: RelationshipStatus.accepted,
        ),
      ];

      state = state.copyWith(foundUsers: expectedFoundUsers);
      final state2 = state.copyWith(setFoundUsersAsNull: true);

      expect(state.foundUsers, expectedFoundUsers);
      expect(state2.foundUsers, null);
    },
  );
}
