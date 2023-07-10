part of 'blood_test_creator_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bool confirmationToLeave = await askForConfirmationToLeave(
          areUnsavedChanges:
              context.read<BloodTestCreatorBloc>().state.canSubmit,
        );
        if (confirmationToLeave) unfocusInputs();
        return confirmationToLeave;
      },
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
    final bool isEditMode = context.select(
      (BloodTestCreatorBloc bloc) => bloc.state.bloodTest != null,
    );

    return FilledButton(
      onPressed: isDisabled
          ? null
          : () {
              _onPressed(context);
            },
      child: Text(
        isEditMode ? Str.of(context).save : Str.of(context).add,
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
