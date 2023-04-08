import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/profile/bloc/profile_identities_state.dart';

void main() {
  late ProfileIdentitiesState state;

  setUp(() {
    state = const ProfileIdentitiesState(
      status: BlocStatusInitial(),
      userId: null,
      username: null,
      surname: null,
      email: null,
    );
  });

  test(
    'copy with state',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusComplete());
    },
  );

  test(
    'copy with user id',
    () {
      const String expectedUserId = 'u1';

      state = state.copyWith(userId: expectedUserId);
      final state2 = state.copyWith();

      expect(state.userId, expectedUserId);
      expect(state2.userId, expectedUserId);
    },
  );

  test(
    'copy with username',
    () {
      const String expectedName = 'Jack';

      state = state.copyWith(username: expectedName);
      final state2 = state.copyWith();

      expect(state.username, expectedName);
      expect(state2.username, expectedName);
    },
  );

  test(
    'copy with surname',
    () {
      const String expectedSurname = 'surname';

      state = state.copyWith(surname: expectedSurname);
      final state2 = state.copyWith();

      expect(state.surname, expectedSurname);
      expect(state2.surname, expectedSurname);
    },
  );

  test(
    'copy with email',
    () {
      const String expectedEmail = 'email@example.com';

      state = state.copyWith(email: expectedEmail);
      final state2 = state.copyWith();

      expect(state.email, expectedEmail);
      expect(state2.email, expectedEmail);
    },
  );
}
