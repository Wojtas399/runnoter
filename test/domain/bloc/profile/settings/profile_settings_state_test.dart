import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/profile/settings/profile_settings_bloc.dart';
import 'package:runnoter/domain/entity/settings.dart';

void main() {
  late ProfileSettingsState state;

  setUp(() {
    state = const ProfileSettingsState(
      status: BlocStatusInitial(),
      themeMode: null,
      language: null,
      distanceUnit: null,
      paceUnit: null,
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
    'copy with theme mode',
    () {
      const ThemeMode expectedThemeMode = ThemeMode.dark;

      state = state.copyWith(themeMode: expectedThemeMode);
      final state2 = state.copyWith();

      expect(state.themeMode, expectedThemeMode);
      expect(state2.themeMode, expectedThemeMode);
    },
  );

  test(
    'copy with language',
    () {
      const Language expectedLanguage = Language.english;

      state = state.copyWith(language: expectedLanguage);
      final state2 = state.copyWith();

      expect(state.language, expectedLanguage);
      expect(state2.language, expectedLanguage);
    },
  );

  test(
    'copy with distance unit',
    () {
      const DistanceUnit expectedDistanceUnit = DistanceUnit.kilometers;

      state = state.copyWith(distanceUnit: expectedDistanceUnit);
      final state2 = state.copyWith();

      expect(state.distanceUnit, expectedDistanceUnit);
      expect(state2.distanceUnit, expectedDistanceUnit);
    },
  );

  test(
    'copy with pace unit',
    () {
      const PaceUnit expectedPaceUnit = PaceUnit.minutesPerKilometer;

      state = state.copyWith(paceUnit: expectedPaceUnit);
      final state2 = state.copyWith();

      expect(state.paceUnit, expectedPaceUnit);
      expect(state2.paceUnit, expectedPaceUnit);
    },
  );
}
