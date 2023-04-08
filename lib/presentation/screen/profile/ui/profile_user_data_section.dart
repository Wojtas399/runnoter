import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../component/value_with_label_and_icon_component.dart';
import '../../../service/dialog_service.dart';
import '../../../service/validation_service.dart';
import '../bloc/profile_identities_bloc.dart';
import '../bloc/profile_identities_event.dart';
import 'profile_delete_account_dialog.dart';
import 'profile_update_email_dialog.dart';
import 'profile_update_password_dialog.dart';

class ProfileUserDataSection extends StatelessWidget {
  const ProfileUserDataSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _Header(),
        SizedBox(height: 16),
        _Name(),
        gap,
        _Surname(),
        gap,
        _Email(),
        gap,
        _ChangePassword(),
        gap,
        _DeleteAccount(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Text(
        AppLocalizations.of(context)!.profile_screen_user_data_section_title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}

class _Name extends StatelessWidget {
  const _Name();

  @override
  Widget build(BuildContext context) {
    final String? username = context.select(
      (ProfileIdentitiesBloc bloc) => bloc.state.username,
    );

    return ValueWithLabelAndIconComponent(
      iconData: Icons.person_outline_rounded,
      label: AppLocalizations.of(context)!.name,
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
    return await askForValue(
      context: context,
      title: AppLocalizations.of(context)!
          .profile_screen_new_username_dialog_title,
      label: AppLocalizations.of(context)!.name,
      textFieldIcon: Icons.person_rounded,
      value: context.read<ProfileIdentitiesBloc>().state.username,
      isValueRequired: true,
      validator: (String? value) {
        if (value != null && !isNameOrSurnameValid(value)) {
          return AppLocalizations.of(context)!.invalid_name_or_surname_message;
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

    return ValueWithLabelAndIconComponent(
      iconData: Icons.person_outline_rounded,
      label: AppLocalizations.of(context)!.surname,
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
    return await askForValue(
      context: context,
      title:
          AppLocalizations.of(context)!.profile_screen_new_surname_dialog_title,
      label: AppLocalizations.of(context)!.surname,
      textFieldIcon: Icons.person_rounded,
      value: context.read<ProfileIdentitiesBloc>().state.surname,
      isValueRequired: true,
      validator: (String? value) {
        if (value != null && !isNameOrSurnameValid(value)) {
          return AppLocalizations.of(context)!.invalid_name_or_surname_message;
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

    return ValueWithLabelAndIconComponent(
      iconData: Icons.email_outlined,
      label: AppLocalizations.of(context)!.email,
      value: email ?? '',
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    await showFullScreenDialog(
      context: context,
      dialog: BlocProvider<ProfileIdentitiesBloc>.value(
        value: context.read<ProfileIdentitiesBloc>(),
        child: const ProfileUpdateEmailDialog(),
      ),
    );
  }
}

class _ChangePassword extends StatelessWidget {
  const _ChangePassword();

  @override
  Widget build(BuildContext context) {
    return ValueWithLabelAndIconComponent(
      iconData: Icons.lock_outline,
      value: AppLocalizations.of(context)!.profile_screen_change_password_label,
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    await showFullScreenDialog(
      context: context,
      dialog: BlocProvider.value(
        value: context.read<ProfileIdentitiesBloc>(),
        child: const ProfileUpdatePasswordDialog(),
      ),
    );
  }
}

class _DeleteAccount extends StatelessWidget {
  const _DeleteAccount();

  @override
  Widget build(BuildContext context) {
    return ValueWithLabelAndIconComponent(
      iconData: Icons.no_accounts_outlined,
      value: AppLocalizations.of(context)!.profile_screen_delete_account_label,
      color: Theme.of(context).colorScheme.error,
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    await showFullScreenDialog(
      context: context,
      dialog: BlocProvider.value(
        value: context.read<ProfileIdentitiesBloc>(),
        child: const ProfileDeleteAccountDialog(),
      ),
    );
  }
}
