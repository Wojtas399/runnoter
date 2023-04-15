import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/repository/user_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../component/bloc_with_status_listener_component.dart';
import '../../../config/navigation/routes.dart';
import '../../../service/dialog_service.dart';
import '../../../service/navigator_service.dart';
import '../bloc/profile_identities_bloc.dart';
import '../bloc/profile_identities_event.dart';
import '../bloc/profile_identities_state.dart';
import '../bloc/profile_settings_bloc.dart';
import '../bloc/profile_settings_event.dart';
import 'profile_content.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _IdentitiesBlocProvider(
      child: _SettingsBlocProvider(
        child: _IdentitiesBlocListener(
          child: ProfileContent(),
        ),
      ),
    );
  }
}

class _IdentitiesBlocProvider extends StatelessWidget {
  final Widget child;

  const _IdentitiesBlocProvider({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileIdentitiesBloc>(
      create: (BuildContext context) => ProfileIdentitiesBloc(
        authService: context.read<AuthService>(),
        userRepository: context.read<UserRepository>(),
      )..add(
          const ProfileIdentitiesEventInitialize(),
        ),
      child: child,
    );
  }
}

class _SettingsBlocProvider extends StatelessWidget {
  final Widget child;

  const _SettingsBlocProvider({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileSettingsBloc>(
      create: (BuildContext context) => ProfileSettingsBloc(
        authService: context.read<AuthService>(),
        userRepository: context.read<UserRepository>(),
      )..add(
          const ProfileSettingsEventInitialize(),
        ),
      child: child,
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
          context: context,
          message: AppLocalizations.of(context)!
              .profile_screen_successfully_saved_data_message,
        );
        break;
      case ProfileInfo.accountDeleted:
        navigateAndRemoveUntil(
          context: context,
          route: const SignInRoute(),
        );
        break;
    }
  }

  void _manageError(BuildContext context, ProfileError error) {
    switch (error) {
      case ProfileError.emailAlreadyInUse:
        showMessageDialog(
          context: context,
          title: AppLocalizations.of(context)!
              .profile_screen_email_already_taken_title,
          message: AppLocalizations.of(context)!
              .profile_screen_email_already_taken_message,
        );
        break;
      case ProfileError.wrongPassword:
        showMessageDialog(
          context: context,
          title:
              AppLocalizations.of(context)!.profile_screen_wrong_password_title,
          message: AppLocalizations.of(context)!
              .profile_screen_wrong_password_message,
        );
        break;
      case ProfileError.wrongCurrentPassword:
        showMessageDialog(
          context: context,
          title: AppLocalizations.of(context)!
              .profile_screen_wrong_current_password_title,
          message: AppLocalizations.of(context)!
              .profile_screen_wrong_current_password_message,
        );
    }
  }
}
