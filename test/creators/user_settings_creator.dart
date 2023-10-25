import 'package:runnoter/data/model/user.dart';

UserSettings createUserSettings({
  ThemeMode themeMode = ThemeMode.light,
  Language language = Language.polish,
  DistanceUnit distanceUnit = DistanceUnit.kilometers,
  PaceUnit paceUnit = PaceUnit.minutesPerKilometer,
}) {
  return UserSettings(
    themeMode: themeMode,
    language: language,
    distanceUnit: distanceUnit,
    paceUnit: paceUnit,
  );
}
