import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/cubit/profile/coach/profile_coach_cubit.dart';
import '../../../domain/cubit/profile/identities/profile_identities_cubit.dart';
import '../../../domain/cubit/profile/settings/profile_settings_cubit.dart';
import '../../component/cubit_with_status_listener_component.dart';
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
        BlocProvider(create: (_) => ProfileIdentitiesCubit()..initialize()),
        BlocProvider(
          create: (_) => ProfileCoachCubit()..initializeCoachListener(),
        ),
        BlocProvider(create: (_) => ProfileSettingsCubit()..initialize()),
      ],
      child: const _IdentitiesCubitListener(
        child: _CoachCubitListener(
          child: ProfileContent(),
        ),
      ),
    );
  }
}

class _IdentitiesCubitListener extends StatefulWidget {
  final Widget child;

  const _IdentitiesCubitListener({required this.child});

  @override
  State<StatefulWidget> createState() => _IdentitiesCubitListenerState();
}

class _IdentitiesCubitListenerState extends State<_IdentitiesCubitListener>
    with AutoRouteAwareStateMixin {
  @override
  void didChangeTabRoute(TabPageRoute previousRoute) {
    context.read<ProfileIdentitiesCubit>().reloadLoggedUser();
    super.didChangeTabRoute(previousRoute);
  }

  @override
  Widget build(BuildContext context) {
    return CubitWithStatusListener<
        ProfileIdentitiesCubit,
        ProfileIdentitiesState,
        ProfileIdentitiesCubitInfo,
        ProfileIdentitiesCubitError>(
      child: widget.child,
      onInfo: (ProfileIdentitiesCubitInfo info) => _manageInfo(context, info),
      onError: (ProfileIdentitiesCubitError error) =>
          _manageError(context, error),
    );
  }

  Future<void> _manageInfo(
    BuildContext context,
    ProfileIdentitiesCubitInfo info,
  ) async {
    final str = Str.of(context);
    switch (info) {
      case ProfileIdentitiesCubitInfo.dataSaved:
        await popRoute();
        showSnackbarMessage(str.profileSuccessfullySavedDataMessage);
        break;
      case ProfileIdentitiesCubitInfo.emailChanged:
        await popRoute();
        if (mounted) await _showEmailVerificationMessage(context);
        break;
      case ProfileIdentitiesCubitInfo.emailVerificationSent:
        await popRoute();
        if (mounted) await _showEmailVerificationMessage(context);
      case ProfileIdentitiesCubitInfo.accountDeleted:
        await showMessageDialog(
          title: str.profileSuccessfullyDeletedAccountDialogTitle,
          message: str.profileSuccessfullyDeletedAccountDialogMessage,
        );
        navigateAndRemoveUntil(const SignInRoute());
        break;
    }
  }

  void _manageError(BuildContext context, ProfileIdentitiesCubitError error) {
    final str = Str.of(context);
    switch (error) {
      case ProfileIdentitiesCubitError.emailAlreadyInUse:
        showMessageDialog(
          title: str.profileEmailAlreadyTakenDialogTitle,
          message: str.profileEmailAlreadyTakenDialogMessage,
        );
        break;
    }
  }

  Future<void> _showEmailVerificationMessage(BuildContext context) async {
    final String? email = context.read<ProfileIdentitiesCubit>().state.email;
    if (email == null) return;
    final str = Str.of(context);
    await showMessageDialog(
      title: str.emailVerificationTitle,
      message:
          '${str.emailVerificationMessage} $email. ${str.emailVerificationInstruction}',
    );
  }
}

class _CoachCubitListener extends StatelessWidget {
  final Widget child;

  const _CoachCubitListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return CubitWithStatusListener<ProfileCoachCubit, ProfileCoachState,
        ProfileCoachCubitInfo, dynamic>(
      onInfo: (ProfileCoachCubitInfo info) => _manageInfo(context, info),
      child: child,
    );
  }

  void _manageInfo(BuildContext context, ProfileCoachCubitInfo info) {
    final str = Str.of(context);
    switch (info) {
      case ProfileCoachCubitInfo.requestAccepted:
        showSnackbarMessage(str.successfullyAcceptedRequest);
        break;
      case ProfileCoachCubitInfo.requestDeleted:
        showSnackbarMessage(str.successfullyDeletedRequest);
        break;
      case ProfileCoachCubitInfo.requestUndid:
        showSnackbarMessage(str.successfullyUndidRequest);
        break;
      case ProfileCoachCubitInfo.coachDeleted:
        showSnackbarMessage(
          str.profileSuccessfullyFinishedCooperationWithCoach,
        );
        break;
    }
  }
}
