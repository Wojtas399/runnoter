part of 'profile_screen.dart';

class _UserDataSection extends StatelessWidget {
  const _UserDataSection();

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: Str.of(context).profileUserData,
        ),
        const SizedBox(height: 16),
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

  Future<String?> _askForNewUsername(BuildContext context) async =>
      await askForValue(
        context: context,
        dialogMode: context.screenWidth > maxMobileWidth
            ? DialogMode.normal
            : DialogMode.fullScreen,
        title: Str.of(context).profileNewUsernameDialogTitle,
        label: Str.of(context).name,
        textFieldIcon: Icons.person_rounded,
        value: context.read<ProfileIdentitiesBloc>().state.username,
        isValueRequired: true,
        validator: (String? value) {
          if (value != null && !isNameOrSurnameValid(value)) {
            return Str.of(context).invalidNameOrSurnameMessage;
          }
          return null;
        },
      );
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

  Future<String?> _askForNewSurname(BuildContext context) async =>
      await askForValue(
        context: context,
        dialogMode: context.screenWidth > maxMobileWidth
            ? DialogMode.normal
            : DialogMode.fullScreen,
        title: Str.of(context).profileNewSurnameDialogTitle,
        label: Str.of(context).surname,
        textFieldIcon: Icons.person_rounded,
        value: context.read<ProfileIdentitiesBloc>().state.surname,
        isValueRequired: true,
        validator: (String? value) {
          if (value != null && !isNameOrSurnameValid(value)) {
            return Str.of(context).invalidNameOrSurnameMessage;
          }
          return null;
        },
      );
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    final String? email = context.select(
      (ProfileIdentitiesBloc bloc) => bloc.state.email,
    );

    return ValueWithLabelAndIcon(
      iconData: Icons.email_outlined,
      label: Str.of(context).email,
      value: email ?? '',
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    final DialogMode dialogMode = context.screenWidth > maxMobileWidth
        ? DialogMode.normal
        : DialogMode.fullScreen;
    final Widget dialog = BlocProvider<ProfileIdentitiesBloc>.value(
      value: context.read<ProfileIdentitiesBloc>(),
      child: _UpdateEmailDialog(dialogMode: dialogMode),
    );
    await switch (dialogMode) {
      DialogMode.normal => showAlertDialog(
          context: context,
          dialog: dialog,
        ),
      DialogMode.fullScreen => showFullScreenDialog(
          context: context,
          dialog: dialog,
        ),
    };
  }
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

  Future<void> _onPressed(BuildContext context) async {
    final DialogMode dialogMode = context.screenWidth > maxMobileWidth
        ? DialogMode.normal
        : DialogMode.fullScreen;
    final Widget dialog = BlocProvider.value(
      value: context.read<ProfileIdentitiesBloc>(),
      child: _UpdatePasswordDialog(dialogMode: dialogMode),
    );
    await switch (dialogMode) {
      DialogMode.normal => showAlertDialog(
          context: context,
          dialog: dialog,
        ),
      DialogMode.fullScreen => showFullScreenDialog(
          context: context,
          dialog: dialog,
        ),
    };
  }
}

class _DeleteAccount extends StatelessWidget {
  const _DeleteAccount();

  @override
  Widget build(BuildContext context) {
    return ValueWithLabelAndIcon(
      iconData: Icons.no_accounts_outlined,
      value: Str.of(context).profileDeleteAccount,
      color: Theme.of(context).colorScheme.error,
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    final DialogMode dialogMode = context.screenWidth > maxMobileWidth
        ? DialogMode.normal
        : DialogMode.fullScreen;
    final Widget dialog = BlocProvider.value(
      value: context.read<ProfileIdentitiesBloc>(),
      child: _DeleteAccountDialog(dialogMode: dialogMode),
    );
    await switch (dialogMode) {
      DialogMode.normal => showAlertDialog(
          context: context,
          dialog: dialog,
        ),
      DialogMode.fullScreen => showFullScreenDialog(
          context: context,
          dialog: dialog,
        ),
    };
  }
}
