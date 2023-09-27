import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/single_child_widget.dart';

import '../../../domain/additional_model/coaching_request_short.dart';
import '../../../domain/additional_model/cubit_status.dart';
import '../../../domain/additional_model/settings.dart' as settings;
import '../../../domain/cubit/calendar/calendar_cubit.dart';
import '../../../domain/cubit/date_range_manager_cubit.dart';
import '../../../domain/cubit/home/home_cubit.dart';
import '../../../domain/cubit/notifications/notifications_cubit.dart';
import '../../dialog/required_data_completion/required_data_completion_dialog.dart';
import '../../formatter/person_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/distance_unit_service.dart';
import '../../service/language_service.dart';
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
      child: MultiBlocListener(
        listeners: const [
          _HomeCubitListener(),
          _NotificationsCubitListener(),
        ],
        child: const HomeContent(),
      ),
    );
  }
}

class _HomeCubitListener extends SingleChildStatelessWidget {
  const _HomeCubitListener();

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return BlocListener<HomeCubit, HomeState>(
      listener: _manageStateChanges,
      child: child,
    );
  }

  void _manageStateChanges(BuildContext context, HomeState state) {
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
  }

  void _manageThemeMode(BuildContext context, settings.ThemeMode themeMode) {
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

  void _manageLanguage(BuildContext context, settings.Language language) {
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

class _NotificationsCubitListener extends SingleChildStatelessWidget {
  const _NotificationsCubitListener();

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return BlocListener<NotificationsCubit, NotificationsState>(
      listener: _manageStateChanges,
      child: child,
    );
  }

  void _manageStateChanges(BuildContext context, NotificationsState state) {
    _manageAcceptedClientRequests(context, state.acceptedClientRequests);
    _manageAcceptedCoachRequest(context, state.acceptedCoachRequest);
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
        context.read<NotificationsCubit>().deleteCoachingRequest(request.id);
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
      context.read<NotificationsCubit>().deleteCoachingRequest(request.id);
    }
  }
}
