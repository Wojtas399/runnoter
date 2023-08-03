import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../domain/bloc/profile/identities/profile_identities_bloc.dart';
import '../../../domain/entity/user.dart';
import '../../component/text/title_text_components.dart';
import '../../component/value_with_label_and_icon_component.dart';
import '../../service/dialog_service.dart';
import '../../service/validation_service.dart';
import 'profile_email_dialog.dart';
import 'profile_gender_dialog.dart';
import 'profile_password_dialog.dart';

class ProfileUserDataSection extends StatelessWidget {
  const ProfileUserDataSection({super.key});

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TitleLarge(Str.of(context).profileUserData),
        ),
        const SizedBox(height: 16),
        const _Gender(),
        gap,
        const _Name(),
        gap,
        const _Surname(),
        gap,
        const _Email(),
        gap,
        const _ChangePassword(),
        gap,
        const _DeleteAccount(),
      ],
    );
  }
}

class _Gender extends StatelessWidget {
  const _Gender();

  @override
  Widget build(BuildContext context) {
    final Gender? gender = context.select(
      (ProfileIdentitiesBloc bloc) => bloc.state.gender,
    );
    final str = Str.of(context);

    return ValueWithLabelAndIcon(
      iconData: MdiIcons.genderMaleFemale,
      label: str.gender,
      value: switch (gender) {
        Gender.male => str.male,
        Gender.female => str.female,
        null => '',
      },
      onPressed: () => _onPressed(context),
    );
  }

  Future<void> _onPressed(BuildContext context) async =>
      showDialogDependingOnScreenSize(
        BlocProvider.value(
          value: context.read<ProfileIdentitiesBloc>(),
          child: const ProfileGenderDialog(),
        ),
      );
}

class _Name extends StatelessWidget {
  const _Name();

  @override
  Widget build(BuildContext context) {
    final String? username = context.select(
      (ProfileIdentitiesBloc bloc) => bloc.state.username,
    );

    return ValueWithLabelAndIcon(
      iconData: Icons.person_outline_rounded,
      label: Str.of(context).name,
      value: username ?? '',
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    final ProfileIdentitiesBloc bloc = context.read<ProfileIdentitiesBloc>();
    final String? newName = await _askForNewUsername(context);
    if (newName != null) {
      bloc.add(
        ProfileIdentitiesEventUpdateUsername(
          username: newName,
        ),
      );
    }
  }

  Future<String?> _askForNewUsername(BuildContext context) async {
    final str = Str.of(context);
    return await askForValue(
      title: str.profileNewUsernameDialogTitle,
      label: str.name,
      textFieldIcon: Icons.person_rounded,
      value: context.read<ProfileIdentitiesBloc>().state.username,
      isValueRequired: true,
      validator: (String? value) {
        if (value != null && !isNameOrSurnameValid(value)) {
          return str.invalidNameOrSurnameMessage;
        }
        return null;
      },
    );
  }
}

class _Surname extends StatelessWidget {
  const _Surname();

  @override
  Widget build(BuildContext context) {
    final String? surname = context.select(
      (ProfileIdentitiesBloc bloc) => bloc.state.surname,
    );

    return ValueWithLabelAndIcon(
      iconData: Icons.person_outline_rounded,
      label: Str.of(context).surname,
      value: surname ?? '',
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    final ProfileIdentitiesBloc bloc = context.read<ProfileIdentitiesBloc>();
    final String? newSurname = await _askForNewSurname(context);
    if (newSurname != null) {
      bloc.add(
        ProfileIdentitiesEventUpdateSurname(
          surname: newSurname,
        ),
      );
    }
  }

  Future<String?> _askForNewSurname(BuildContext context) async {
    final str = Str.of(context);
    return await askForValue(
      title: str.profileNewSurnameDialogTitle,
      label: str.surname,
      textFieldIcon: Icons.person_rounded,
      value: context.read<ProfileIdentitiesBloc>().state.surname,
      isValueRequired: true,
      validator: (String? value) {
        if (value != null && !isNameOrSurnameValid(value)) {
          return str.invalidNameOrSurnameMessage;
        }
        return null;
      },
    );
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    final String? email = context.select(
      (ProfileIdentitiesBloc bloc) => bloc.state.email,
    );
    final bool? isEmailVerified = context.select(
      (ProfileIdentitiesBloc bloc) => bloc.state.isEmailVerified,
    );
    String? value = email;
    if (isEmailVerified == false && value != null) {
      value += ' (not verified)';
    }

    return ValueWithLabelAndIcon(
      iconData: Icons.email_outlined,
      label: Str.of(context).email,
      value: value ?? '--',
      onPressed: () => _onPressed(context),
    );
  }

  Future<void> _onPressed(BuildContext context) async =>
      await showDialogDependingOnScreenSize(
        BlocProvider<ProfileIdentitiesBloc>.value(
          value: context.read<ProfileIdentitiesBloc>(),
          child: const ProfileEmailDialog(),
        ),
      );
}

class _ChangePassword extends StatelessWidget {
  const _ChangePassword();

  @override
  Widget build(BuildContext context) {
    return ValueWithLabelAndIcon(
      iconData: Icons.lock_outline,
      value: Str.of(context).profileChangePassword,
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  Future<void> _onPressed(BuildContext context) async =>
      showDialogDependingOnScreenSize(
        BlocProvider.value(
          value: context.read<ProfileIdentitiesBloc>(),
          child: const ProfilePasswordDialog(),
        ),
      );
}

class _DeleteAccount extends StatefulWidget {
  const _DeleteAccount();

  @override
  State<StatefulWidget> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<_DeleteAccount> {
  @override
  Widget build(BuildContext context) {
    return ValueWithLabelAndIcon(
      iconData: Icons.no_accounts_outlined,
      value: Str.of(context).profileDeleteAccount,
      color: Theme.of(context).colorScheme.error,
      onPressed: _onPressed,
    );
  }

  Future<void> _onPressed() async {
    final str = Str.of(context);
    final bool confirmed = await askForConfirmation(
      title: str.profileDeleteAccountDialogTitle,
      message: str.profileDeleteAccountDialogMessage,
      confirmButtonLabel: str.delete,
      confirmButtonColor: Theme.of(context).colorScheme.error,
    );
    if (!confirmed) return;
    final bool reauthenticated = await askForReauthentication();
    if (reauthenticated && mounted) {
      context.read<ProfileIdentitiesBloc>().add(
            const ProfileIdentitiesEventDeleteAccount(),
          );
    }
  }
}
