import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../data/model/user.dart';
import '../../component/gap/gap_components.dart';
import '../../component/text/title_text_components.dart';
import '../../component/value_with_label_and_icon_component.dart';
import '../../cubit/profile/identities/profile_identities_cubit.dart';
import '../../formatter/account_type_formatter.dart';
import '../../formatter/date_formatter.dart';
import '../../formatter/gender_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/validation_service.dart';
import 'profile_date_of_birth_dialog.dart';
import 'profile_email_dialog.dart';
import 'profile_gender_dialog.dart';
import 'profile_password_dialog.dart';

class ProfileUserDataSection extends StatelessWidget {
  const ProfileUserDataSection({super.key});

  @override
  Widget build(BuildContext context) {
    const gap = Gap8();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TitleLarge(Str.of(context).profileUserData),
        ),
        const Gap16(),
        const _AccountType(),
        gap,
        const _Gender(),
        gap,
        const _Name(),
        gap,
        const _Surname(),
        gap,
        const _DateOfBirth(),
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

class _AccountType extends StatelessWidget {
  const _AccountType();

  @override
  Widget build(BuildContext context) {
    final AccountType? accountType = context.select(
      (ProfileIdentitiesCubit cubit) => cubit.state.accountType,
    );

    return ValueWithLabelAndIcon(
      iconData: Icons.badge_outlined,
      label: Str.of(context).accountType,
      value: accountType?.toUIFormat(context) ?? '',
    );
  }
}

class _Gender extends StatelessWidget {
  const _Gender();

  @override
  Widget build(BuildContext context) {
    final Gender? gender = context.select(
      (ProfileIdentitiesCubit cubit) => cubit.state.gender,
    );

    return ValueWithLabelAndIcon(
      iconData: MdiIcons.genderMaleFemale,
      label: Str.of(context).gender,
      value: gender?.toUIFormat(context) ?? '',
      onPressed: () => _onPressed(context),
    );
  }

  Future<void> _onPressed(BuildContext context) async =>
      showDialogDependingOnScreenSize(
        BlocProvider.value(
          value: context.read<ProfileIdentitiesCubit>(),
          child: const ProfileGenderDialog(),
        ),
      );
}

class _Name extends StatelessWidget {
  const _Name();

  @override
  Widget build(BuildContext context) {
    final String? name = context.select(
      (ProfileIdentitiesCubit cubit) => cubit.state.name,
    );

    return ValueWithLabelAndIcon(
      iconData: Icons.person_outline_rounded,
      label: Str.of(context).name,
      value: name ?? '',
      onPressed: () => _onPressed(context),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    final ProfileIdentitiesCubit cubit = context.read<ProfileIdentitiesCubit>();
    final String? newName = await _askForNewUsername(context);
    if (newName != null) cubit.updateName(newName);
  }

  Future<String?> _askForNewUsername(BuildContext context) async {
    final str = Str.of(context);
    return await askForValue(
      title: str.profileNewUsernameDialogTitle,
      label: str.name,
      textFieldIcon: Icons.person_rounded,
      value: context.read<ProfileIdentitiesCubit>().state.name,
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
      (ProfileIdentitiesCubit cubit) => cubit.state.surname,
    );

    return ValueWithLabelAndIcon(
      iconData: Icons.person_outline_rounded,
      label: Str.of(context).surname,
      value: surname ?? '',
      onPressed: () => _onPressed(context),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    final ProfileIdentitiesCubit cubit = context.read<ProfileIdentitiesCubit>();
    final String? newSurname = await _askForNewSurname(context);
    if (newSurname != null) cubit.updateSurname(newSurname);
  }

  Future<String?> _askForNewSurname(BuildContext context) async {
    final str = Str.of(context);
    return await askForValue(
      title: str.profileNewSurnameDialogTitle,
      label: str.surname,
      textFieldIcon: Icons.person_rounded,
      value: context.read<ProfileIdentitiesCubit>().state.surname,
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

class _DateOfBirth extends StatelessWidget {
  const _DateOfBirth();

  @override
  Widget build(BuildContext context) {
    final DateTime? dateOfBirth = context.select(
      (ProfileIdentitiesCubit cubit) => cubit.state.dateOfBirth,
    );

    return ValueWithLabelAndIcon(
      iconData: Icons.cake_outlined,
      label: Str.of(context).dateOfBirth,
      value: dateOfBirth?.toDateWithDots() ?? '',
      onPressed: () => _onPressed(context),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    final ProfileIdentitiesCubit cubit = context.read<ProfileIdentitiesCubit>();
    final DateTime? newDateOfBirth = await _askForNewDateOfBirth(context);
    if (newDateOfBirth != null) cubit.updateDateOfBirth(newDateOfBirth);
  }

  Future<DateTime?> _askForNewDateOfBirth(BuildContext context) async =>
      await showDialogDependingOnScreenSize(
        BlocProvider<ProfileIdentitiesCubit>.value(
          value: context.read<ProfileIdentitiesCubit>(),
          child: const ProfileDateOfBirthDialog(),
        ),
      );
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    final String? email = context.select(
      (ProfileIdentitiesCubit cubit) => cubit.state.email,
    );
    final bool? isEmailVerified = context.select(
      (ProfileIdentitiesCubit cubit) => cubit.state.isEmailVerified,
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
        BlocProvider<ProfileIdentitiesCubit>.value(
          value: context.read<ProfileIdentitiesCubit>(),
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
      onPressed: () => _onPressed(context),
    );
  }

  Future<void> _onPressed(BuildContext context) async =>
      showDialogDependingOnScreenSize(
        BlocProvider.value(
          value: context.read<ProfileIdentitiesCubit>(),
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
      title: Text(str.profileDeleteAccountDialogTitle),
      content: Text(str.profileDeleteAccountDialogMessage),
      confirmButtonLabel: str.delete,
      confirmButtonColor: Theme.of(context).colorScheme.error,
    );
    if (!confirmed) return;
    final bool reauthenticated = await askForReauthentication();
    if (reauthenticated && mounted) {
      context.read<ProfileIdentitiesCubit>().deleteAccount();
    }
  }
}
