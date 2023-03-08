part of 'sign_in_screen.dart';

class _SignInSubmitButton extends StatelessWidget {
  const _SignInSubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isButtonDisabled = context.select(
      (SignInBloc bloc) => bloc.state.isButtonDisabled,
    );

    return BigButton(
      label: AppLocalizations.of(context)!.sign_in_screen_button_label,
      isDisabled: isButtonDisabled,
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  void _onPressed(BuildContext context) {
    context.read<SignInBloc>().add(
          const SignInEventSubmit(),
        );
  }
}
