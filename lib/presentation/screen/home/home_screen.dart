import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/home/home_bloc.dart';
import '../../../domain/entity/settings.dart' as settings;
import '../../../domain/repository/user_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../config/navigation/routes.dart';
import '../../service/dialog_service.dart';
import '../../service/distance_unit_service.dart';
import '../../service/language_service.dart';
import '../../service/navigator_service.dart';
import '../../service/pace_unit_service.dart';
import '../../service/theme_service.dart';
import '../screens.dart';

part 'home_app_bar.dart';
part 'home_bottom_navigation_bar.dart';
part 'home_content.dart';
part 'home_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _BlocProvider(
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
    return BlocWithStatusListener<HomeBloc, HomeState, HomeInfo, dynamic>(
      child: child,
      onInfo: (HomeInfo info) {
        _manageInfo(context, info);
      },
      onStateChanged: (HomeState state) {
        _manageStateChanges(context, state);
      },
    );
  }

  void _manageInfo(BuildContext context, HomeInfo info) {
    switch (info) {
      case HomeInfo.userSignedOut:
        context.read<ThemeService>().changeTheme(ThemeMode.system);
        navigateAndRemoveUntil(
          context: context,
          route: const SignInRoute(),
        );
        break;
    }
  }

  void _manageStateChanges(
    BuildContext context,
    HomeState state,
  ) {
    if (state.themeMode != null) {
      _manageThemeMode(context, state.themeMode!);
    }
    if (state.language != null) {
      _manageLanguage(context, state.language!);
    }
    if (state.distanceUnit != null) {
      context.read<DistanceUnitService>().changeUnit(state.distanceUnit!);
    }
    if (state.paceUnit != null) {
      context.read<PaceUnitService>().changeUnit(state.paceUnit!);
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
