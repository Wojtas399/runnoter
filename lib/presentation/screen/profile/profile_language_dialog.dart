import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/profile/settings/profile_settings_bloc.dart';
import '../../../domain/entity/settings.dart';
import '../../component/text/body_text_components.dart';
import '../../extension/context_extensions.dart';
import '../../formatter/settings_formatter.dart';
import '../../service/navigator_service.dart';

class ProfileLanguageDialog extends StatelessWidget {
  const ProfileLanguageDialog({super.key});

  @override
  Widget build(BuildContext context) =>
      context.isMobileSize ? const _FullScreenDialog() : const _NormalDialog();
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
            SizedBox(height: 16),
            _OptionsToSelect(),
            SizedBox(height: 16),
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
              SizedBox(height: 16),
              _OptionsToSelect(),
              SizedBox(height: 16),
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
      child: BodyLarge(Str.of(context).languageSelect),
    );
  }
}

class _OptionsToSelect extends StatelessWidget {
  const _OptionsToSelect();

  @override
  Widget build(BuildContext context) {
    final Language? selectedLanguage = context.select(
      (ProfileSettingsBloc bloc) => bloc.state.language,
    );

    return Column(
      children: Language.values
          .map(
            (Language language) => RadioListTile<Language>(
              title: Text(language.toUIFormat(context)),
              value: language,
              groupValue: selectedLanguage,
              onChanged: (Language? language) {
                _onLanguageChanged(context, language);
              },
            ),
          )
          .toList(),
    );
  }

  void _onLanguageChanged(
    BuildContext context,
    Language? newLanguage,
  ) {
    if (newLanguage != null) {
      context.read<ProfileSettingsBloc>().add(
            ProfileSettingsEventUpdateLanguage(newLanguage: newLanguage),
          );
    }
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
