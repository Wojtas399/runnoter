import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/model/settings.dart';

extension ThemeModeFormatter on ThemeMode {
  String toUIFormat(BuildContext context) {
    switch (this) {
      case ThemeMode.system:
        return AppLocalizations.of(context)!.settings_theme_mode_system;
      case ThemeMode.light:
        return AppLocalizations.of(context)!.settings_theme_mode_light;
      case ThemeMode.dark:
        return AppLocalizations.of(context)!.settings_theme_mode_dark;
    }
  }
}

extension LanguageFormatter on Language {
  String toUIFormat(BuildContext context) {
    switch (this) {
      case Language.polish:
        return AppLocalizations.of(context)!.settings_language_polish;
      case Language.english:
        return AppLocalizations.of(context)!.settings_language_english;
    }
  }
}
