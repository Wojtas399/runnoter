import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/model/settings.dart';

extension ThemeModeFormatter on ThemeMode {
  String toUIFormat(BuildContext context) {
    final str = Str.of(context);
    switch (this) {
      case ThemeMode.system:
        return str.themeModeSystem;
      case ThemeMode.light:
        return str.themeModeLight;
      case ThemeMode.dark:
        return str.themeModeDark;
    }
  }
}

extension LanguageFormatter on Language {
  String toUIFormat(BuildContext context) {
    final str = Str.of(context);
    switch (this) {
      case Language.polish:
        return str.languagePolish;
      case Language.english:
        return str.languageEnglish;
      case Language.system:
        return str.languageSystem;
    }
  }
}

extension DistanceUnitFormatter on DistanceUnit {
  String toUIFormat(BuildContext context) {
    switch (this) {
      case DistanceUnit.kilometers:
        return Str.of(context).distance_unit_kilometers;
      case DistanceUnit.miles:
        return Str.of(context).distance_unit_miles;
    }
  }
}

extension PaceUnitFormatter on PaceUnit {
  String toUIFormat(BuildContext context) {
    switch (this) {
      case PaceUnit.minutesPerKilometer:
        return Str.of(context).pace_unit_minutes_per_kilometer;
      case PaceUnit.minutesPerMile:
        return Str.of(context).pace_unit_minutes_per_miles;
      case PaceUnit.kilometersPerHour:
        return Str.of(context).pace_unit_kilometers_per_hour;
      case PaceUnit.milesPerHour:
        return Str.of(context).pace_unit_miles_per_hour;
    }
  }
}
