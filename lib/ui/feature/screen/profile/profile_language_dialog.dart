import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../data/additional_model/settings.dart';
import '../../../../domain/cubit/profile/settings/profile_settings_cubit.dart';
import '../../../component/gap/gap_components.dart';
import '../../../component/responsive_layout_component.dart';
import '../../../component/text/body_text_components.dart';
import '../../../formatter/settings_formatter.dart';
import '../../../service/navigator_service.dart';

class ProfileLanguageDialog extends StatelessWidget {
  const ProfileLanguageDialog({super.key});

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
      title: Text(str.language),
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
            _SystemLanguageDescription(),
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
        title: Text(Str.of(context).language),
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
              _SystemLanguageDescription(),
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
      child: BodyLarge(Str.of(context).languageSelection),
    );
  }
}

class _OptionsToSelect extends StatelessWidget {
  const _OptionsToSelect();

  @override
  Widget build(BuildContext context) {
    final Language? selectedLanguage = context.select(
      (ProfileSettingsCubit cubit) => cubit.state.language,
    );

    return Column(
      children: Language.values
          .map(
            (Language language) => RadioListTile<Language>(
              title: Text(language.toUIFormat(context)),
              value: language,
              groupValue: selectedLanguage,
              onChanged: context.read<ProfileSettingsCubit>().updateLanguage,
            ),
          )
          .toList(),
    );
  }
}

class _SystemLanguageDescription extends StatelessWidget {
  const _SystemLanguageDescription();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: BodyMedium(
        Str.of(context).systemLanguageDescription,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
}
