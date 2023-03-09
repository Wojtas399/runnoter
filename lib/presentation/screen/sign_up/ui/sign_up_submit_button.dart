part of 'sign_up_screen.dart';

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (SignUpBloc bloc) => bloc.state.isSubmitButtonDisabled,
    );

    return BigButton(
      label: AppLocalizations.of(context)!.sign_up_screen_button_label,
      isDisabled: isDisabled,
      onPressed: () {},
    );
  }
}
