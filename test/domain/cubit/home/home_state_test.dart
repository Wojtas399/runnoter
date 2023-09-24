import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/coaching_request_short.dart';
import 'package:runnoter/domain/additional_model/cubit_status.dart';
import 'package:runnoter/domain/additional_model/settings.dart';
import 'package:runnoter/domain/cubit/home/home_cubit.dart';
import 'package:runnoter/domain/entity/user.dart';

import '../../../creators/person_creator.dart';

void main() {
  late HomeState state;

  setUp(() {
    state = const HomeState(status: CubitStatusInitial());
  });

  test(
    'copy with status, '
    'should set new value or should set complete status if new value is null',
    () {
      const CubitStatus expected = CubitStatusLoading();

      state = state.copyWith(status: expected);
      final state2 = state.copyWith();

      expect(state.status, expected);
      expect(state2.status, const CubitStatusComplete());
    },
  );

  test(
    'copy with accountType, '
    'should set new value or should copy current value if new value is null',
    () {
      const AccountType expected = AccountType.coach;

      state = state.copyWith(accountType: expected);
      final state2 = state.copyWith();

      expect(state.accountType, expected);
      expect(state2.accountType, expected);
    },
  );

  test(
    'copy with loggedUserName, '
    'should set new value or should copy current value if new value is null',
    () {
      const String expected = 'name';

      state = state.copyWith(loggedUserName: expected);
      final state2 = state.copyWith();

      expect(state.loggedUserName, expected);
      expect(state2.loggedUserName, expected);
    },
  );

  test(
    'copy with appSettings, '
    'should set new value or should copy current value if new value is null',
    () {
      const Settings expected = Settings(
        themeMode: ThemeMode.dark,
        language: Language.polish,
        distanceUnit: DistanceUnit.miles,
        paceUnit: PaceUnit.milesPerHour,
      );

      state = state.copyWith(appSettings: expected);
      final state2 = state.copyWith();

      expect(state.appSettings, expected);
      expect(state2.appSettings, expected);
    },
  );

  test(
    'copy with acceptedClientRequests, '
    'should set new value or should set as empty array if new value is null',
    () {
      final List<CoachingRequestShort> expected = [
        CoachingRequestShort(id: 'r1', personToDisplay: createPerson(id: 'u1')),
        CoachingRequestShort(id: 'r2', personToDisplay: createPerson(id: 'u2')),
      ];

      state = state.copyWith(
        acceptedClientRequests: expected,
      );
      final state2 = state.copyWith();

      expect(state.acceptedClientRequests, expected);
      expect(state2.acceptedClientRequests, const []);
    },
  );

  test(
    'copy with acceptedCoachRequest, '
    'should set new value',
    () {
      final CoachingRequestShort expected = CoachingRequestShort(
        id: 'r1',
        personToDisplay: createPerson(id: 'p1'),
      );

      state = state.copyWith(acceptedCoachRequest: expected);
      final state2 = state.copyWith();

      expect(state.acceptedCoachRequest, expected);
      expect(state2.acceptedCoachRequest, null);
    },
  );

  test(
    'copy with numberOfChatsWithUnreadMessages, '
    'should set new value or should copy current value if new value is null',
    () {
      const int expected = 5;

      state = state.copyWith(numberOfChatsWithUnreadMessages: expected);
      final state2 = state.copyWith();

      expect(state.numberOfChatsWithUnreadMessages, expected);
      expect(state2.numberOfChatsWithUnreadMessages, expected);
    },
  );
}
