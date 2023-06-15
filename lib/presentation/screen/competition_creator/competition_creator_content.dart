part of 'competition_creator_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bool confirmationToLeave = await askForConfirmationToLeave(
          context: context,
          areUnsavedChanges:
              context.read<CompetitionCreatorBloc>().state.canSubmit,
        );
        if (confirmationToLeave) unfocusInputs();
        return confirmationToLeave;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            Str.of(context).competitionCreatorScreenTitle,
          ),
        ),
        body: GestureDetector(
          onTap: unfocusInputs,
          child: const ScrollableContent(
            child: Paddings24(
              child: Column(
                children: [
                  _Form(),
                  SizedBox(height: 40),
                  _SubmitButton(),
                ],
              ),
            ),
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
    final bool isEditMode = context.select(
      (CompetitionCreatorBloc bloc) => bloc.state.competition != null,
    );
    final bool isDisabled = context.select(
      (CompetitionCreatorBloc bloc) => !bloc.state.canSubmit,
    );

    return BigButton(
      label: isEditMode ? Str.of(context).save : Str.of(context).add,
      isDisabled: isDisabled,
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  void _onPressed(BuildContext context) {
    context.read<CompetitionCreatorBloc>().add(
          const CompetitionCreatorEventSubmit(),
        );
  }
}
