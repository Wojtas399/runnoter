import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/entity/user.dart';
import 'package:runnoter/ui/cubit/profile/settings/profile_settings_cubit.dart';

void main() {
  late ProfileSettingsState state;

  setUp(() {
    state = const ProfileSettingsState();
  });

  test(
    'copy with theme mode, '
    'should copy current value if new value is null',
    () {
      const ThemeMode expectedThemeMode = ThemeMode.dark;

      state = state.copyWith(themeMode: expectedThemeMode);
      final state2 = state.copyWith();

      expect(state.themeMode, expectedThemeMode);
      expect(state2.themeMode, expectedThemeMode);
    },
  );

  test(
    'copy with language, '
    'should copy current value if new value is null',
    () {
      const Language expectedLanguage = Language.english;

      state = state.copyWith(language: expectedLanguage);
      final state2 = state.copyWith();

      expect(state.language, expectedLanguage);
      expect(state2.language, expectedLanguage);
    },
  );

  test(
    'copy with distance unit, '
    'should copy current value if new value is null',
    () {
      const DistanceUnit expectedDistanceUnit = DistanceUnit.kilometers;

      state = state.copyWith(distanceUnit: expectedDistanceUnit);
      final state2 = state.copyWith();

      expect(state.distanceUnit, expectedDistanceUnit);
      expect(state2.distanceUnit, expectedDistanceUnit);
    },
  );

  test(
    'copy with pace unit, '
    'should copy current value if new value is null',
    () {
      const PaceUnit expectedPaceUnit = PaceUnit.minutesPerKilometer;

      state = state.copyWith(paceUnit: expectedPaceUnit);
      final state2 = state.copyWith();

      expect(state.paceUnit, expectedPaceUnit);
      expect(state2.paceUnit, expectedPaceUnit);
    },
  );
}
