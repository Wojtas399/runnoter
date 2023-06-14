part of 'blood_test_creator_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => askForConfirmationToLeave(
        context: context,
        areUnsavedChanges: context.read<BloodTestCreatorBloc>().state.canSubmit,
      ),
      child: Scaffold(
        appBar: const _AppBar(),
        body: GestureDetector(
          onTap: () {
            unfocusInputs();
          },
          child: const Column(
            children: [
              _DateSection(),
              Expanded(
                child: _ParametersSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (BloodTestCreatorBloc bloc) => !bloc.state.canSubmit,
    );

    return FilledButton(
      onPressed: isDisabled
          ? null
          : () {
              _onPressed(context);
            },
      child: Text(
        Str.of(context).save,
      ),
    );
  }

  void _onPressed(BuildContext context) {
    unfocusInputs();
    context.read<BloodTestCreatorBloc>().add(
          const BloodTestCreatorEventSubmit(),
        );
  }
}
