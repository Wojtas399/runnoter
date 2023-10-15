import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/single_child_widget.dart';

import '../../../component/cubit_with_status_listener_component.dart';
import '../../../config/navigation/router.dart';
import '../../../service/dialog_service.dart';
import '../../../service/navigator_service.dart';
import 'cubit/coach/profile_coach_cubit.dart';
import 'cubit/identities/profile_identities_cubit.dart';
import 'cubit/settings/profile_settings_cubit.dart';
import 'profile_content.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProfileIdentitiesCubit()..initialize()),
        BlocProvider(create: (_) => ProfileCoachCubit()..initialize()),
        BlocProvider(create: (_) => ProfileSettingsCubit()..initialize()),
      ],
      child: MultiBlocListener(
        listeners: const [
          _IdentitiesCubitListener(),
          _CoachCubitListener(),
        ],
        child: const ProfileContent(),
      ),
    );
  }
}

class _IdentitiesCubitListener extends SingleChildStatefulWidget {
  const _IdentitiesCubitListener();

  @override
  State<StatefulWidget> createState() => _IdentitiesCubitListenerState();
}

class _IdentitiesCubitListenerState
    extends SingleChildState<_IdentitiesCubitListener>
    with AutoRouteAwareStateMixin {
  @override
  void didChangeTabRoute(TabPageRoute previousRoute) {
    context.read<ProfileIdentitiesCubit>().reloadLoggedUser();
    super.didChangeTabRoute(previousRoute);
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return CubitWithStatusListener<
        ProfileIdentitiesCubit,
        ProfileIdentitiesState,
        ProfileIdentitiesCubitInfo,
        ProfileIdentitiesCubitError>(
      onInfo: (ProfileIdentitiesCubitInfo info) => _manageInfo(context, info),
      onError: (ProfileIdentitiesCubitError error) =>
          _manageError(context, error),
      child: child,
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

class _CoachCubitListener extends SingleChildStatelessWidget {
  const _CoachCubitListener();

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return CubitWithStatusListener<ProfileCoachCubit, ProfileCoachState,
        ProfileCoachCubitInfo, ProfileCoachCubitError>(
      onInfo: (ProfileCoachCubitInfo info) => _manageInfo(context, info),
      onError: (ProfileCoachCubitError error) => _manageError(context, error),
      child: child,
    );
  }

  void _manageInfo(BuildContext context, ProfileCoachCubitInfo info) {
    final str = Str.of(context);
    switch (info) {
      case ProfileCoachCubitInfo.requestAccepted:
        showSnackbarMessage(str.successfullyAcceptedRequest);
      case ProfileCoachCubitInfo.requestDeleted:
        showSnackbarMessage(str.successfullyDeletedRequest);
      case ProfileCoachCubitInfo.requestUndid:
        showSnackbarMessage(str.successfullyUndidRequest);
      case ProfileCoachCubitInfo.coachDeleted:
        showSnackbarMessage(
          str.profileSuccessfullyFinishedCooperationWithCoach,
        );
    }
  }

  void _manageError(BuildContext context, ProfileCoachCubitError error) {
    final str = Str.of(context);
    switch (error) {
      case ProfileCoachCubitError.userNoLongerHasCoach:
        showMessageDialog(
          title: str.profileUserNoLongerHasCoachDialogTitle,
          message: str.profileUserNoLongerHasCoachDialogMessage,
        );
    }
  }
}
