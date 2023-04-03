import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/model/settings.dart' as settings;
import '../../../service/navigator_service.dart';

class ProfileUpdateTheme extends StatefulWidget {
  const ProfileUpdateTheme({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<ProfileUpdateTheme> {
  settings.ThemeMode? _selectedThemeMode;

  @override
  void initState() {
    _selectedThemeMode = settings.ThemeMode.light;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  groupValue: _selectedThemeMode,
                  onChanged: _onThemeModeSelected,
                ),
                RadioListTile<settings.ThemeMode>(
                  title: Text(
                    AppLocalizations.of(context)!.settings_theme_mode_dark,
                  ),
                  value: settings.ThemeMode.dark,
                  groupValue: _selectedThemeMode,
                  onChanged: _onThemeModeSelected,
                ),
                RadioListTile<settings.ThemeMode>(
                  title: Text(
                    AppLocalizations.of(context)!.settings_theme_mode_system,
                  ),
                  value: settings.ThemeMode.system,
                  groupValue: _selectedThemeMode,
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
    setState(() {
      _selectedThemeMode = themeMode;
    });
  }
}
