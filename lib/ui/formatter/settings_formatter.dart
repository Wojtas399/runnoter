import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/entity/user.dart';

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
