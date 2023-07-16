import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/home/home_bloc.dart';
import 'package:runnoter/domain/entity/settings.dart';

void main() {
  late HomeState state;

  setUp(() {
    state = const HomeState(
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
    'copy with logged user name',
    () {
      const String expectedLoggedUserName = 'name';

      state = state.copyWith(loggedUserName: expectedLoggedUserName);
      final state2 = state.copyWith();

      expect(state.loggedUserName, expectedLoggedUserName);
      expect(state2.loggedUserName, expectedLoggedUserName);
    },
  );

  test(
    'copy with app settings',
    () {
      const Settings expectedSettings = Settings(
        themeMode: ThemeMode.dark,
        language: Language.polish,
        distanceUnit: DistanceUnit.miles,
        paceUnit: PaceUnit.milesPerHour,
      );

      state = state.copyWith(appSettings: expectedSettings);
      final state2 = state.copyWith();

      expect(state.appSettings, expectedSettings);
      expect(state2.appSettings, expectedSettings);
    },
  );
}
