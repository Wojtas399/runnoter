part of 'sign_in_screen.dart';

class _Form extends StatelessWidget {
  const _Form();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _Email(),
        SizedBox(height: 24),
        _Password(),
      ],
    );
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label: Str.of(context).email,
      icon: Icons.email,
      onChanged: (String? value) {
        _onChanged(value, context);
      },
    );
  }

  void _onChanged(String? value, BuildContext context) {
    if (value != null) {
      context.read<SignInBloc>().add(
            SignInEventEmailChanged(email: value),
          );
    }
  }
}

class _Password extends StatelessWidget {
  const _Password();

  @override
  Widget build(BuildContext context) {
    return PasswordTextFieldComponent(
      onChanged: (String? value) {
        _onChanged(value, context);
      },
    );
  }

  void _onChanged(String? value, BuildContext context) {
    if (value != null) {
      context.read<SignInBloc>().add(
            SignInEventPasswordChanged(password: value),
          );
    }
  }
}
