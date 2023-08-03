import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return BlocProvider(
      create: (_) => ProfileIdentitiesBloc()
        ..add(const ProfileIdentitiesEventInitialize()),
      child: BlocProvider(
        create: (_) =>
            ProfileSettingsBloc()..add(const ProfileSettingsEventInitialize()),
        child: const _IdentitiesBlocListener(
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
    switch (info) {
      case ProfileIdentitiesBlocInfo.dataSaved:
        final str = Str.of(context);
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
          title: Str.of(context).profileSuccessfullyDeletedAccountDialogTitle,
          message:
              Str.of(context).profileSuccessfullyDeletedAccountDialogMessage,
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
