import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/additional_model/settings.dart';
import 'package:runnoter/data/entity/user.dart';
import 'package:runnoter/domain/additional_model/cubit_status.dart';
import 'package:runnoter/ui/cubit/home/home_cubit.dart';

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
}
