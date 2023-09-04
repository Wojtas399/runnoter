import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/profile/coach/profile_coach_bloc.dart';
import '../../../domain/bloc/profile/identities/profile_identities_bloc.dart';
import '../../../domain/bloc/profile/settings/profile_settings_bloc.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../config/navigation/router.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import 'profile_content.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProfileIdentitiesBloc()
            ..add(const ProfileIdentitiesEventInitialize()),
        ),
        BlocProvider(
          create: (_) => ProfileCoachBloc()
            ..add(const ProfileCoachEventInitializeCoachListener()),
        ),
        BlocProvider(
          create: (_) => ProfileSettingsBloc()
            ..add(const ProfileSettingsEventInitialize()),
        ),
      ],
      child: const _IdentitiesBlocListener(
        child: _CoachBlocListener(
          child: ProfileContent(),
        ),
      ),
    );
  }
}

class _IdentitiesBlocListener extends StatefulWidget {
  final Widget child;

  const _IdentitiesBlocListener({
    required this.child,
  });

  @override
  State<StatefulWidget> createState() => _IdentitiesBlocListenerState();
}

class _IdentitiesBlocListenerState extends State<_IdentitiesBlocListener>
    with AutoRouteAwareStateMixin {
  @override
  void didChangeTabRoute(TabPageRoute previousRoute) {
    context.read<ProfileIdentitiesBloc>().add(
          const ProfileIdentitiesEventReloadLoggedUser(),
        );
    super.didChangeTabRoute(previousRoute);
  }

  @override
  Widget build(BuildContext context) {
    return BlocWithStatusListener<ProfileIdentitiesBloc, ProfileIdentitiesState,
        ProfileIdentitiesBlocInfo, ProfileIdentitiesBlocError>(
      child: widget.child,
      onInfo: (ProfileIdentitiesBlocInfo info) => _manageInfo(context, info),
      onError: (ProfileIdentitiesBlocError error) =>
          _manageError(context, error),
    );
  }

  Future<void> _manageInfo(
    BuildContext context,
    ProfileIdentitiesBlocInfo info,
  ) async {
    final str = Str.of(context);
    switch (info) {
      case ProfileIdentitiesBlocInfo.dataSaved:
        await popRoute();
        showSnackbarMessage(str.profileSuccessfullySavedDataMessage);
        break;
      case ProfileIdentitiesBlocInfo.emailChanged:
        await popRoute();
        if (mounted) await _showEmailVerificationMessage(context);
        break;
      case ProfileIdentitiesBlocInfo.emailVerificationSent:
        await popRoute();
        if (mounted) await _showEmailVerificationMessage(context);
      case ProfileIdentitiesBlocInfo.accountDeleted:
        await showMessageDialog(
          title: str.profileSuccessfullyDeletedAccountDialogTitle,
          message: str.profileSuccessfullyDeletedAccountDialogMessage,
        );
        navigateAndRemoveUntil(const SignInRoute());
        break;
    }
  }

  void _manageError(BuildContext context, ProfileIdentitiesBlocError error) {
    final str = Str.of(context);
    switch (error) {
      case ProfileIdentitiesBlocError.emailAlreadyInUse:
        showMessageDialog(
          title: str.profileEmailAlreadyTakenDialogTitle,
          message: str.profileEmailAlreadyTakenDialogMessage,
        );
        break;
    }
  }

  Future<void> _showEmailVerificationMessage(BuildContext context) async {
    final String? email = context.read<ProfileIdentitiesBloc>().state.email;
    if (email == null) return;
    final str = Str.of(context);
    await showMessageDialog(
      title: str.emailVerificationTitle,
      message:
          '${str.emailVerificationMessage} $email. ${str.emailVerificationInstruction}',
    );
  }
}

class _CoachBlocListener extends StatelessWidget {
  final Widget child;

  const _CoachBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocWithStatusListener<ProfileCoachBloc, ProfileCoachState,
        ProfileCoachBlocInfo, dynamic>(
      onInfo: (ProfileCoachBlocInfo info) => _manageInfo(context, info),
      onStateChanged: _manageState,
      child: child,
    );
  }

  void _manageInfo(BuildContext context, ProfileCoachBlocInfo info) {
    final str = Str.of(context);
    switch (info) {
      case ProfileCoachBlocInfo.requestAccepted:
        showSnackbarMessage(str.successfullyAcceptedRequest);
        break;
      case ProfileCoachBlocInfo.requestDeleted:
        showSnackbarMessage(str.successfullyDeletedRequest);
        break;
      case ProfileCoachBlocInfo.requestUndid:
        showSnackbarMessage(str.successfullyUndidRequest);
        break;
      case ProfileCoachBlocInfo.coachDeleted:
        showSnackbarMessage(
          str.profileSuccessfullyFinishedCooperationWithCoach,
        );
        break;
    }
  }

  void _manageState(ProfileCoachState state) {
    if (state.idOfChatWithCoach != null) {
      navigateTo(ChatRoute(chatId: state.idOfChatWithCoach));
    }
  }
}
