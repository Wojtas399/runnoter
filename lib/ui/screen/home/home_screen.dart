import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/single_child_widget.dart';

import '../../../../data/model/user.dart' as user;
import '../../../../dependency_injection.dart';
import '../../../../domain/model/coaching_request_with_person.dart';
import '../../component/cubit_with_status_listener_component.dart';
import '../../config/navigation/router.dart';
import '../../cubit/calendar/calendar_cubit.dart';
import '../../cubit/date_range_manager_cubit.dart';
import '../../cubit/home/home_cubit.dart';
import '../../cubit/notifications/notifications_cubit.dart';
import '../../dialog/required_data_completion/required_data_completion_dialog.dart';
import '../../formatter/person_formatter.dart';
import '../../model/cubit_status.dart';
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

  void _manageStateChanges(BuildContext context, HomeState state) {
    if (state.status is CubitStatusComplete &&
        state.loggedUserName == null &&
        state.userSettings == null) {
      showDialogDependingOnScreenSize(
        const RequiredDataCompletionDialog(),
        barrierDismissible: false,
      );
      return;
    }
    final user.UserSettings? userSettings = state.userSettings;
    if (userSettings != null) {
      _manageThemeMode(context, userSettings.themeMode);
      _manageLanguage(context, userSettings.language);
      context.read<DistanceUnitService>().changeUnit(userSettings.distanceUnit);
      context.read<PaceUnitService>().changeUnit(userSettings.paceUnit);
    }
  }

  void _manageThemeMode(BuildContext context, user.ThemeMode themeMode) {
    final ThemeService themeService = context.read<ThemeService>();
    switch (themeMode) {
      case user.ThemeMode.dark:
        themeService.changeTheme(ThemeMode.dark);
        break;
      case user.ThemeMode.light:
        themeService.changeTheme(ThemeMode.light);
        break;
      case user.ThemeMode.system:
        themeService.changeTheme(ThemeMode.system);
        break;
    }
  }

  void _manageLanguage(BuildContext context, user.Language language) {
    final LanguageService languageService = context.read<LanguageService>();
    switch (language) {
      case user.Language.polish:
        languageService.changeLanguage(AppLanguage.polish);
        break;
      case user.Language.english:
        languageService.changeLanguage(AppLanguage.english);
        break;
      case user.Language.system:
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
    List<CoachingRequestWithPerson> acceptedClientRequests,
  ) {
    if (acceptedClientRequests.isNotEmpty) {
      for (final request in acceptedClientRequests) {
        showSnackbarMessage(
          Str.of(context).homeNewClientInfo(
            request.person.toFullNameWithEmail(),
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
    CoachingRequestWithPerson? request,
  ) {
    if (request != null) {
      showSnackbarMessage(
        Str.of(context).homeNewCoachInfo(
          request.person.toFullNameWithEmail(),
        ),
        showCloseIcon: true,
        duration: const Duration(seconds: 6),
      );
      context.read<NotificationsCubit>().deleteCoachingRequest(request.id);
    }
  }
}
