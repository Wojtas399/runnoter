import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../component/value_with_label_and_icon_component.dart';
import '../../../service/dialog_service.dart';
import '../../../service/validation_service.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';

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
        _Username(),
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
    return Text(
      AppLocalizations.of(context)!.profile_screen_user_data_section_title,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}

class _Username extends StatelessWidget {
  const _Username();

  @override
  Widget build(BuildContext context) {
    final String? username = context.select(
      (ProfileBloc bloc) => bloc.state.username,
    );

    return ValueWithLabelAndIconComponent(
      iconData: Icons.person_outline,
      label: AppLocalizations.of(context)!.profile_screen_username_label,
      value: username ?? '',
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    final ProfileBloc bloc = context.read<ProfileBloc>();
    final String? newName = await _askForNewUsername(context);
    if (newName != null) {
      bloc.add(
        ProfileEventUpdateUsername(
          username: newName,
        ),
      );
    }
  }

  Future<String?> _askForNewUsername(BuildContext context) async {
    return await askForValue(
      context: context,
      title: 'Podaj nowe imię',
      label: AppLocalizations.of(context)!.profile_screen_username_label,
      value: context.read<ProfileBloc>().state.username,
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
      (ProfileBloc bloc) => bloc.state.surname,
    );

    return ValueWithLabelAndIconComponent(
      iconData: Icons.person_outline,
      label: AppLocalizations.of(context)!.profile_screen_surname_label,
      value: surname ?? '',
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    final ProfileBloc bloc = context.read<ProfileBloc>();
    final String? newSurname = await _askForNewSurname(context);
    if (newSurname != null) {
      bloc.add(
        ProfileEventUpdateSurname(
          surname: newSurname,
        ),
      );
    }
  }

  Future<String?> _askForNewSurname(BuildContext context) async {
    return await askForValue(
      context: context,
      title: 'Podaj nowe nazwisko',
      label: AppLocalizations.of(context)!.profile_screen_surname_label,
      value: context.read<ProfileBloc>().state.surname,
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
      (ProfileBloc bloc) => bloc.state.email,
    );

    return ValueWithLabelAndIconComponent(
      iconData: Icons.email_outlined,
      label: AppLocalizations.of(context)!.profile_screen_email_label,
      value: email ?? '',
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
        //TODO
      },
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
        //TODO
      },
    );
  }
}
