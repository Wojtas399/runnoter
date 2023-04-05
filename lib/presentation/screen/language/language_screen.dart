import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/model/settings.dart';
import '../../../domain/repository/user_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../formatter/settings_formatter.dart';
import '../../service/language_service.dart';
import '../../service/navigator_service.dart';
import 'language_cubit.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _CubitProvider(
      child: _CubitListener(
        child: _Content(),
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

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.language_label,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _Header(),
            SizedBox(height: 16),
            _OptionsToSelect(),
          ],
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
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Text(
        AppLocalizations.of(context)!.language_selection_text,
        style: Theme.of(context).textTheme.bodyLarge,
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
    Language? language,
  ) {
    if (language != null) {
      context.read<LanguageCubit>().updateLanguage(
            language: language,
          );
    }
  }
}
