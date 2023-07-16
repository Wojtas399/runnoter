import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/bloc/home/home_bloc.dart';
import '../../../domain/entity/settings.dart' as settings;
import '../../../domain/repository/user_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/nullable_text_component.dart';
import '../../component/text/label_text_components.dart';
import '../../config/navigation/router.dart';
import '../../config/ui_sizes.dart';
import '../../extension/context_extensions.dart';
import '../../service/dialog_service.dart';
import '../../service/distance_unit_service.dart';
import '../../service/language_service.dart';
import '../../service/navigator_service.dart';
import '../../service/pace_unit_service.dart';
import '../../service/theme_service.dart';

part 'home_app_bar.dart';
part 'home_bottom_navigation_bar.dart';
part 'home_content.dart';
part 'home_navigation_drawer.dart';
part 'home_navigation_rail.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _BlocProvider(
      child: _BlocListener(
        child: _Content(),
      ),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final Widget child;

  const _BlocProvider({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(
        authService: context.read<AuthService>(),
        userRepository: context.read<UserRepository>(),
      )..add(
          const HomeEventInitialize(),
        ),
      child: child,
    );
  }
}

class _BlocListener extends StatelessWidget {
  final Widget child;

  const _BlocListener({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocWithStatusListener<HomeBloc, HomeState, HomeBlocInfo, dynamic>(
      child: child,
      onInfo: (HomeBlocInfo info) {
        _manageInfo(context, info);
      },
      onStateChanged: (HomeState state) {
        _manageStateChanges(context, state);
      },
    );
  }

  void _manageInfo(BuildContext context, HomeBlocInfo info) {
    switch (info) {
      case HomeBlocInfo.userSignedOut:
        context.read<ThemeService>().changeTheme(ThemeMode.system);
        navigateAndRemoveUntil(const SignInRoute());
        break;
    }
  }

  void _manageStateChanges(
    BuildContext context,
    HomeState state,
  ) {
    final settings.Settings? appSettings = state.appSettings;
    if (appSettings != null) {
      _manageThemeMode(context, appSettings.themeMode);
      _manageLanguage(context, appSettings.language);
      context.read<DistanceUnitService>().changeUnit(appSettings.distanceUnit);
      context.read<PaceUnitService>().changeUnit(appSettings.paceUnit);
    }
  }

  void _manageThemeMode(
    BuildContext context,
    settings.ThemeMode themeMode,
  ) {
    final ThemeService themeService = context.read<ThemeService>();
    switch (themeMode) {
      case settings.ThemeMode.dark:
        themeService.changeTheme(ThemeMode.dark);
        break;
      case settings.ThemeMode.light:
        themeService.changeTheme(ThemeMode.light);
        break;
      case settings.ThemeMode.system:
        themeService.changeTheme(ThemeMode.system);
        break;
    }
  }

  void _manageLanguage(
    BuildContext context,
    settings.Language language,
  ) {
    final LanguageService languageService = context.read<LanguageService>();
    switch (language) {
      case settings.Language.polish:
        languageService.changeLanguage(AppLanguage.polish);
        break;
      case settings.Language.english:
        languageService.changeLanguage(AppLanguage.english);
        break;
      case settings.Language.system:
        languageService.changeLanguage(AppLanguage.system);
        break;
    }
  }
}
