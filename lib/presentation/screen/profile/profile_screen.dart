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
        ..add(
          const ProfileIdentitiesEventInitialize(),
        ),
      child: BlocProvider(
        create: (_) => ProfileSettingsBloc()
          ..add(
            const ProfileSettingsEventInitialize(),
          ),
        child: const _IdentitiesBlocListener(
          child: ProfileContent(),
        ),
      ),
    );
  }
}

class _IdentitiesBlocListener extends StatelessWidget {
  final Widget child;

  const _IdentitiesBlocListener({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocWithStatusListener<ProfileIdentitiesBloc, ProfileIdentitiesState,
        ProfileInfo, ProfileError>(
      child: child,
      onInfo: (ProfileInfo info) {
        _manageInfo(context, info);
      },
      onError: (ProfileError error) {
        _manageError(context, error);
      },
    );
  }

  void _manageInfo(BuildContext context, ProfileInfo info) {
    switch (info) {
      case ProfileInfo.savedData:
        showSnackbarMessage(
          Str.of(context).profileSuccessfullySavedDataMessage,
        );
        break;
      case ProfileInfo.accountDeleted:
        navigateAndRemoveUntil(const SignInRoute());
        break;
    }
  }

  void _manageError(BuildContext context, ProfileError error) {
    final str = Str.of(context);
    switch (error) {
      case ProfileError.emailAlreadyInUse:
        showMessageDialog(
          title: str.profileEmailAlreadyTakenDialogTitle,
          message: str.profileEmailAlreadyTakenDialogMessage,
        );
        break;
      case ProfileError.wrongPassword:
        showMessageDialog(
          title: str.profileWrongPasswordDialogTitle,
          message: str.profileWrongPasswordDialogMessage,
        );
        break;
      case ProfileError.wrongCurrentPassword:
        showMessageDialog(
          title: str.profileWrongCurrentPasswordDialogTitle,
          message: str.profileWrongCurrentPasswordDialogMessage,
        );
    }
  }
}
