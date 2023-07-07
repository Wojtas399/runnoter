import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/profile/language_cubit.dart';
import '../../../domain/entity/settings.dart';
import '../../../domain/repository/user_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/text/body_text_components.dart';
import '../../extension/context_extensions.dart';
import '../../formatter/settings_formatter.dart';
import '../../service/language_service.dart';
import '../../service/navigator_service.dart';

class ProfileLanguageDialog extends StatelessWidget {
  const ProfileLanguageDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _CubitProvider(
      child: _CubitListener(
        child: context.isMobileSize
            ? const _FullScreenDialog()
            : const _NormalDialog(),
      ),
    );
  }
}

class _CubitProvider extends StatelessWidget {
  final Widget child;

  const _CubitProvider({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LanguageCubit(
        authService: context.read<AuthService>(),
        userRepository: context.read<UserRepository>(),
      )..initialize(),
      child: child,
    );
  }
}

class _CubitListener extends StatelessWidget {
  final Widget child;

  const _CubitListener({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<LanguageCubit, Language?>(
      listener: (BuildContext context, Language? language) {
        if (language != null) {
          _manageLanguage(context, language);
        }
      },
      child: child,
    );
  }

  void _manageLanguage(BuildContext context, Language language) {
    final LanguageService languageService = context.read<LanguageService>();
    switch (language) {
      case Language.polish:
        languageService.changeLanguage(AppLanguage.polish);
        break;
      case Language.english:
        languageService.changeLanguage(AppLanguage.english);
        break;
      case Language.system:
        languageService.changeLanguage(AppLanguage.system);
    }
  }
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
          onPressed: () => navigateBack(context: context),
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
        leading: IconButton(
          onPressed: () => navigateBack(context: context),
          icon: const Icon(Icons.close),
        ),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
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
      child: BodyLarge(
        Str.of(context).languageSelect,
      ),
    );
  }
}

class _OptionsToSelect extends StatelessWidget {
  const _OptionsToSelect();

  @override
  Widget build(BuildContext context) {
    final Language? selectedLanguage = context.select(
      (LanguageCubit cubit) => cubit.state,
    );

    return Column(
      children: Language.values
          .map(
            (Language language) => RadioListTile<Language>(
              title: Text(
                language.toUIFormat(context),
              ),
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
      context.read<LanguageCubit>().updateLanguage(
            newLanguage: newLanguage,
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
