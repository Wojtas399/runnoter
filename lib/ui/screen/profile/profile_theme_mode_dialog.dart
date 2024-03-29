import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../data/model/user.dart' as settings;
import '../../component/gap/gap_components.dart';
import '../../component/responsive_layout_component.dart';
import '../../component/text/body_text_components.dart';
import '../../cubit/profile/settings/profile_settings_cubit.dart';
import '../../service/navigator_service.dart';

class ProfileThemeModeDialog extends StatelessWidget {
  const ProfileThemeModeDialog({super.key});

  @override
  Widget build(BuildContext context) => const ResponsiveLayout(
        mobileBody: _FullScreenDialog(),
        desktopBody: _NormalDialog(),
      );
}

class _NormalDialog extends StatelessWidget {
  const _NormalDialog();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return AlertDialog(
      title: Text(str.themeMode),
      contentPadding: const EdgeInsets.symmetric(vertical: 24),
      content: const SizedBox(
        width: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(),
            Gap16(),
            _OptionsToSelect(),
            Gap16(),
            _SystemThemeDescription(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: popRoute,
          child: Text(str.close),
        ),
      ],
    );
  }
}

class _FullScreenDialog extends StatelessWidget {
  const _FullScreenDialog();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Str.of(context).themeMode),
        leading: const CloseButton(),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(),
              Gap16(),
              _OptionsToSelect(),
              Gap16(),
              _SystemThemeDescription(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: BodyLarge(Str.of(context).themeModeSelection),
    );
  }
}

class _OptionsToSelect extends StatelessWidget {
  const _OptionsToSelect();

  @override
  Widget build(BuildContext context) {
    final settings.ThemeMode? selectedThemeMode = context.select(
      (ProfileSettingsCubit cubit) => cubit.state.themeMode,
    );
    final str = Str.of(context);

    return Column(
      children: [
        RadioListTile<settings.ThemeMode>(
          title: Text(str.themeModeLight),
          value: settings.ThemeMode.light,
          groupValue: selectedThemeMode,
          onChanged: context.read<ProfileSettingsCubit>().updateThemeMode,
        ),
        RadioListTile<settings.ThemeMode>(
          title: Text(str.themeModeDark),
          value: settings.ThemeMode.dark,
          groupValue: selectedThemeMode,
          onChanged: context.read<ProfileSettingsCubit>().updateThemeMode,
        ),
        RadioListTile<settings.ThemeMode>(
          title: Text(str.themeModeSystem),
          value: settings.ThemeMode.system,
          groupValue: selectedThemeMode,
          onChanged: context.read<ProfileSettingsCubit>().updateThemeMode,
        ),
      ],
    );
  }
}

class _SystemThemeDescription extends StatelessWidget {
  const _SystemThemeDescription();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: BodyMedium(
        Str.of(context).systemThemeModeDescription,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
}
