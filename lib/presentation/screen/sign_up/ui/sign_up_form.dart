part of 'sign_up_screen.dart';

class _SignUpForm extends StatelessWidget {
  const _SignUpForm();

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 24);

    return Column(
      children: const [
        _Name(),
        gap,
        _Surname(),
        gap,
        _Email(),
        gap,
        _Password(),
        gap,
        _PasswordConfirmation(),
      ],
    );
  }
}

class _Name extends StatelessWidget {
  const _Name();

  @override
  Widget build(BuildContext context) {
    final bool isValid = context.select(
      (SignUpBloc bloc) => bloc.state.isNameValid,
    );

    return TextFieldComponent(
      icon: Icons.person,
      label: AppLocalizations.of(context)!.name,
      isRequired: true,
      onChanged: (String? value) {
        _onChanged(value, context);
      },
      validator: (_) {
        if (!isValid) {
          return AppLocalizations.of(context)!.invalid_name_or_surname_message;
        }
        return null;
      },
    );
  }

  void _onChanged(String? value, BuildContext context) {
    context.read<SignUpBloc>().add(
          SignUpEventNameChanged(name: value ?? ''),
        );
  }
}

class _Surname extends StatelessWidget {
  const _Surname();

  @override
  Widget build(BuildContext context) {
    final bool isValid = context.select(
      (SignUpBloc bloc) => bloc.state.isSurnameValid,
    );

    return TextFieldComponent(
      icon: Icons.person,
      label: AppLocalizations.of(context)!.surname,
      isRequired: true,
      onChanged: (String? value) {
        _onChanged(value, context);
      },
      validator: (_) {
        if (!isValid) {
          return AppLocalizations.of(context)!.invalid_name_or_surname_message;
        }
        return null;
      },
    );
  }

  void _onChanged(String? value, BuildContext context) {
    context.read<SignUpBloc>().add(
          SignUpEventSurnameChanged(surname: value ?? ''),
        );
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    final bool isValid = context.select(
      (SignUpBloc bloc) => bloc.state.isEmailValid,
    );

    return TextFieldComponent(
      icon: Icons.email,
      label: AppLocalizations.of(context)!.email,
      isRequired: true,
      onChanged: (String? value) {
        _onChanged(value, context);
      },
      validator: (_) {
        if (!isValid) {
          return AppLocalizations.of(context)!.invalid_email_message;
        }
        return null;
      },
    );
  }

  void _onChanged(String? value, BuildContext context) {
    context.read<SignUpBloc>().add(
          SignUpEventEmailChanged(email: value ?? ''),
        );
  }
}

class _Password extends StatelessWidget {
  const _Password();

  @override
  Widget build(BuildContext context) {
    final bool isValid = context.select(
      (SignUpBloc bloc) => bloc.state.isPasswordValid,
    );

    return PasswordTextFieldComponent(
      isRequired: true,
      onChanged: (String? value) {
        _onChanged(value, context);
      },
      validator: (_) {
        if (!isValid) {
          return AppLocalizations.of(context)!.invalid_password_message;
        }
        return null;
      },
    );
  }

  void _onChanged(String? value, BuildContext context) {
    context.read<SignUpBloc>().add(
          SignUpEventPasswordChanged(password: value ?? ''),
        );
  }
}

class _PasswordConfirmation extends StatelessWidget {
  const _PasswordConfirmation();

  @override
  Widget build(BuildContext context) {
    final bool isValid = context.select(
      (SignUpBloc bloc) => bloc.state.isPasswordConfirmationValid,
    );

    return PasswordTextFieldComponent(
      label: AppLocalizations.of(context)!.passwordConfirmation,
      isRequired: true,
      onChanged: (String? value) {
        _onChanged(value, context);
      },
      validator: (_) {
        if (!isValid) {
          return AppLocalizations.of(context)!
              .invalid_password_confirmation_message;
        }
        return null;
      },
    );
  }

  void _onChanged(String? value, BuildContext context) {
    context.read<SignUpBloc>().add(
          SignUpEventPasswordConfirmationChanged(
            passwordConfirmation: value ?? '',
          ),
        );
  }
}
