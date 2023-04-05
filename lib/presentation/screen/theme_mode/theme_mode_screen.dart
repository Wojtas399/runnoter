import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/model/settings.dart' as settings;
import '../../service/navigator_service.dart';

class ThemeModeScreen extends StatelessWidget {
  const ThemeModeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const settings.ThemeMode selectedThemeMode = settings.ThemeMode.light;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.profile_screen_theme_mode_label,
        ),
        leading: IconButton(
          onPressed: () {
            navigateBack(context: context);
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Column(
              children: [
                RadioListTile<settings.ThemeMode>(
                  title: Text(
                    AppLocalizations.of(context)!.settings_theme_mode_light,
                  ),
                  value: settings.ThemeMode.light,
                  groupValue: selectedThemeMode,
                  onChanged: _onThemeModeSelected,
                ),
                RadioListTile<settings.ThemeMode>(
                  title: Text(
                    AppLocalizations.of(context)!.settings_theme_mode_dark,
                  ),
                  value: settings.ThemeMode.dark,
                  groupValue: selectedThemeMode,
                  onChanged: _onThemeModeSelected,
                ),
                RadioListTile<settings.ThemeMode>(
                  title: Text(
                    AppLocalizations.of(context)!.settings_theme_mode_system,
                  ),
                  value: settings.ThemeMode.system,
                  groupValue: selectedThemeMode,
                  onChanged: _onThemeModeSelected,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onThemeModeSelected(settings.ThemeMode? themeMode) {
    //TODO
  }
}
