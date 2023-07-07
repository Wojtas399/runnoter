import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/bloc_status.dart';
import '../../../domain/bloc/profile/identities/profile_identities_bloc.dart';
import '../../../domain/bloc/profile/settings/profile_settings_bloc.dart';
import '../../../domain/entity/settings.dart' as settings;
import '../../../domain/repository/blood_test_repository.dart';
import '../../../domain/repository/health_measurement_repository.dart';
import '../../../domain/repository/race_repository.dart';
import '../../../domain/repository/user_repository.dart';
import '../../../domain/repository/workout_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/password_text_field_component.dart';
import '../../component/text/body_text_components.dart';
import '../../component/text/title_text_components.dart';
import '../../component/text_field_component.dart';
import '../../component/value_with_label_and_icon_component.dart';
import '../../config/navigation/routes.dart';
import '../../config/screen_sizes.dart';
import '../../formatter/distance_unit_formatter.dart';
import '../../formatter/pace_unit_formatter.dart';
import '../../formatter/settings_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import '../../service/utils.dart';
import '../../service/validation_service.dart';

part 'profile_content.dart';
part 'profile_delete_account_dialog.dart';
part 'profile_settings_section.dart';
part 'profile_update_email_dialog.dart';
part 'profile_update_password_dialog.dart';
part 'profile_user_data_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _IdentitiesBlocProvider(
      child: _SettingsBlocProvider(
        child: _IdentitiesBlocListener(
          child: _Content(),
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
        workoutRepository: context.read<WorkoutRepository>(),
        healthMeasurementRepository:
            context.read<HealthMeasurementRepository>(),
        bloodTestRepository: context.read<BloodTestRepository>(),
        raceRepository: context.read<RaceRepository>(),
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
          message: Str.of(context).profileSuccessfullySavedDataMessage,
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
    final str = Str.of(context);
    switch (error) {
      case ProfileError.emailAlreadyInUse:
        showMessageDialog(
          context: context,
          title: str.profileEmailAlreadyTakenDialogTitle,
          message: str.profileEmailAlreadyTakenDialogMessage,
        );
        break;
      case ProfileError.wrongPassword:
        showMessageDialog(
          context: context,
          title: str.profileWrongPasswordDialogTitle,
          message: str.profileWrongPasswordDialogMessage,
        );
        break;
      case ProfileError.wrongCurrentPassword:
        showMessageDialog(
          context: context,
          title: str.profileWrongCurrentPasswordDialogTitle,
          message: str.profileWrongCurrentPasswordDialogMessage,
        );
    }
  }
}
