part of 'sign_in_screen.dart';

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isButtonDisabled = context.select(
      (SignInBloc bloc) => bloc.state.isButtonDisabled,
    );

    return BigButton(
      label: Str.of(context).signInButtonLabel,
      isDisabled: isButtonDisabled,
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  void _onPressed(BuildContext context) {
    unfocusInputs();
    context.read<SignInBloc>().add(
          const SignInEventSubmit(),
        );
  }
}
