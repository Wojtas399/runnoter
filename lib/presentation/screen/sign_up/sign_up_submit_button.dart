part of 'sign_up_screen.dart';

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (SignUpBloc bloc) => bloc.state.isSubmitButtonDisabled,
    );

    return BigButton(
      label: Str.of(context).signUpButtonLabel,
      isDisabled: isDisabled,
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  void _onPressed(BuildContext context) {
    unfocusInputs();
    context.read<SignUpBloc>().add(
          const SignUpEventSubmit(),
        );
  }
}
