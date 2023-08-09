import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/user_basic_info.dart';
import 'package:runnoter/domain/bloc/users_search/users_search_bloc.dart';
import 'package:runnoter/domain/entity/user.dart';

void main() {
  late UsersSearchState state;

  setUp(() {
    state = const UsersSearchState(
      status: BlocStatusInitial(),
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
    'copy with found users',
    () {
      const List<UserBasicInfo> expectedFoundUsers = [
        UserBasicInfo(
          id: 'c1',
          gender: Gender.male,
          name: 'name1',
          surname: 'surname1',
          email: 'email1@example.com',
        ),
        UserBasicInfo(
          id: 'c2',
          gender: Gender.female,
          name: 'name2',
          surname: 'surname2',
          email: 'email2@example.com',
        ),
      ];

      state = state.copyWith(foundUsers: expectedFoundUsers);
      final state2 = state.copyWith();

      expect(state.foundUsers, expectedFoundUsers);
      expect(state2.foundUsers, null);
    },
  );
}
