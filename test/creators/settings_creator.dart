import 'package:runnoter/domain/additional_model/settings.dart';

Settings createSettings({
  ThemeMode themeMode = ThemeMode.light,
  Language language = Language.polish,
  DistanceUnit distanceUnit = DistanceUnit.kilometers,
  PaceUnit paceUnit = PaceUnit.minutesPerKilometer,
}) {
  return Settings(
    themeMode: themeMode,
    language: language,
    distanceUnit: distanceUnit,
    paceUnit: paceUnit,
  );
}
