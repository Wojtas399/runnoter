import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../dependency_injection.dart';
import '../../../domain/additional_model/coaching_request_short.dart';
import '../../../domain/additional_model/cubit_status.dart';
import '../../../domain/additional_model/settings.dart' as settings;
import '../../../domain/cubit/calendar/calendar_cubit.dart';
import '../../../domain/cubit/date_range_manager_cubit.dart';
import '../../../domain/cubit/home/home_cubit.dart';
import '../../../domain/cubit/notifications/notifications_cubit.dart';
import '../../component/cubit_with_status_listener_component.dart';
import '../../config/navigation/router.dart';
import '../../dialog/required_data_completion/required_data_completion_dialog.dart';
import '../../formatter/person_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/distance_unit_service.dart';
import '../../service/language_service.dart';
import '../../service/navigator_service.dart';
import '../../service/pace_unit_service.dart';
import '../../service/theme_service.dart';
import 'home_content.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()..initialize()),
        BlocProvider(
          create: (_) => CalendarCubit()..initialize(DateRangeType.week),
        ),
        BlocProvider(
          create: (_) => NotificationsCubit()
            ..listenToAcceptedRequests()
            ..listenToReceivedRequests()
            ..listenToAwaitingMessages(),
        ),
      ],
      child: const _CubitListener(
        child: HomeContent(),
      ),
    );
  }
}

class _CubitListener extends StatelessWidget {
  final Widget child;

  const _CubitListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return CubitWithStatusListener<HomeCubit, HomeState, HomeCubitInfo,
        dynamic>(
      child: child,
      onInfo: (HomeCubitInfo info) => _manageInfo(context, info),
      onStateChanged: (HomeState state) => _manageStateChanges(context, state),
    );
  }

  void _manageInfo(BuildContext context, HomeCubitInfo info) {
    switch (info) {
      case HomeCubitInfo.userSignedOut:
        context.read<ThemeService>().changeTheme(ThemeMode.system);
        navigateAndRemoveUntil(const SignInRoute());
        resetGetItRepositories();
        break;
    }
  }

  void _manageStateChanges(
    BuildContext context,
    HomeState state,
  ) {
    if (state.status is CubitStatusComplete &&
        state.loggedUserName == null &&
        state.appSettings == null) {
      showDialogDependingOnScreenSize(
        const RequiredDataCompletionDialog(),
        barrierDismissible: false,
      );
      return;
    }
    final settings.Settings? appSettings = state.appSettings;
    if (appSettings != null) {
      _manageThemeMode(context, appSettings.themeMode);
      _manageLanguage(context, appSettings.language);
      context.read<DistanceUnitService>().changeUnit(appSettings.distanceUnit);
      context.read<PaceUnitService>().changeUnit(appSettings.paceUnit);
    }
    _manageAcceptedClientRequests(context, state.acceptedClientRequests);
    _manageAcceptedCoachRequest(context, state.acceptedCoachRequest);
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

  void _manageAcceptedClientRequests(
    BuildContext context,
    List<CoachingRequestShort> acceptedClientRequests,
  ) {
    if (acceptedClientRequests.isNotEmpty) {
      for (final request in acceptedClientRequests) {
        showSnackbarMessage(
          Str.of(context).homeNewClientInfo(
            request.personToDisplay.toFullNameWithEmail(),
          ),
          showCloseIcon: true,
          duration: const Duration(seconds: 6),
        );
        context.read<HomeCubit>().deleteCoachingRequest(request.id);
      }
    }
  }

  void _manageAcceptedCoachRequest(
    BuildContext context,
    CoachingRequestShort? request,
  ) {
    if (request != null) {
      showSnackbarMessage(
        Str.of(context).homeNewCoachInfo(
          request.personToDisplay.toFullNameWithEmail(),
        ),
        showCloseIcon: true,
        duration: const Duration(seconds: 6),
      );
      context.read<HomeCubit>().deleteCoachingRequest(request.id);
    }
  }
}
