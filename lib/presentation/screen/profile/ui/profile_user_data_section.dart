import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../component/value_with_label_and_icon_component.dart';

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
    return Text(
      AppLocalizations.of(context)!.profile_screen_user_data_section_title,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}

class _Name extends StatelessWidget {
  const _Name();

  @override
  Widget build(BuildContext context) {
    return ValueWithLabelAndIconComponent(
      iconData: Icons.person_outline,
      label: AppLocalizations.of(context)!.profile_screen_username_label,
      value: 'Wojtas',
      onPressed: () {
        //TODO
      },
    );
  }
}

class _Surname extends StatelessWidget {
  const _Surname();

  @override
  Widget build(BuildContext context) {
    return ValueWithLabelAndIconComponent(
      iconData: Icons.person_outline,
      label: AppLocalizations.of(context)!.profile_screen_surname_label,
      value: 'Piekielny',
      onPressed: () {
        //TODO
      },
    );
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    return ValueWithLabelAndIconComponent(
      iconData: Icons.email_outlined,
      label: AppLocalizations.of(context)!.profile_screen_email_label,
      value: 'wojtekp@example.com',
      onPressed: () {
        //TODO
      },
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
