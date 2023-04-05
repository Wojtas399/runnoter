import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/model/settings.dart';

extension ThemeModeFormatter on ThemeMode {
  String toUIFormat(BuildContext context) {
    switch (this) {
      case ThemeMode.system:
        return AppLocalizations.of(context)!.theme_mode_system;
      case ThemeMode.light:
        return AppLocalizations.of(context)!.theme_mode_light;
      case ThemeMode.dark:
        return AppLocalizations.of(context)!.theme_mode_dark;
    }
  }
}

extension LanguageFormatter on Language {
  String toUIFormat(BuildContext context) {
    switch (this) {
      case Language.polish:
        return AppLocalizations.of(context)!.language_polish;
      case Language.english:
        return AppLocalizations.of(context)!.language_english;
      case Language.system:
        return AppLocalizations.of(context)!.language_system;
    }
  }
}

extension DistanceUnitFormatter on DistanceUnit {
  String toUIFormat(BuildContext context) {
    switch (this) {
      case DistanceUnit.kilometers:
        return AppLocalizations.of(context)!.settings_distance_unit_kilometers;
      case DistanceUnit.miles:
        return AppLocalizations.of(context)!.settings_distance_unit_miles;
    }
  }
}

extension PaceUnitFormatter on PaceUnit {
  String toUIFormat(BuildContext context) {
    switch (this) {
      case PaceUnit.minutesPerKilometer:
        return AppLocalizations.of(context)!
            .settings_pace_unit_minutes_per_kilometer;
      case PaceUnit.minutesPerMile:
        return AppLocalizations.of(context)!
            .settings_pace_unit_minutes_per_miles;
      case PaceUnit.kilometersPerHour:
        return AppLocalizations.of(context)!
            .settings_pace_unit_kilometers_per_hour;
      case PaceUnit.milesPerHour:
        return AppLocalizations.of(context)!.settings_pace_unit_miles_per_hour;
    }
  }
}
