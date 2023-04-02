import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
