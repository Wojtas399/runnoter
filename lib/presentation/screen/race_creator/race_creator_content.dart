part of 'race_creator_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bool confirmationToLeave = await askForConfirmationToLeave(
          areUnsavedChanges: context.read<RaceCreatorBloc>().state.canSubmit,
        );
        if (confirmationToLeave) unfocusInputs();
        return confirmationToLeave;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const _AppBarTitle(),
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: unfocusInputs,
            child: const ScreenAdjustableBody(
              maxContentWidth: bigContentWidth,
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

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    final Race? race = context.select(
      (RaceCreatorBloc bloc) => bloc.state.race,
    );
    String title = Str.of(context).raceCreatorNewRaceTitle;
    if (race != null) {
      title = Str.of(context).raceCreatorEditRaceTitle;
    }
    return Text(title);
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isEditMode = context.select(
      (RaceCreatorBloc bloc) => bloc.state.race != null,
    );
    final bool isDisabled = context.select(
      (RaceCreatorBloc bloc) => !bloc.state.canSubmit,
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
    context.read<RaceCreatorBloc>().add(
          const RaceCreatorEventSubmit(),
        );
  }
}
