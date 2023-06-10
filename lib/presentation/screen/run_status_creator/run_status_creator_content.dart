part of 'run_status_creator_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Str.of(context).runStatusCreatorScreenTitle,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ScrollableContent(
          child: GestureDetector(
            onTap: () {
              unfocusInputs();
            },
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(24),
              child: const Column(
                children: [
                  _StatusType(),
                  SizedBox(height: 24),
                  _Form(),
                  SizedBox(height: 24),
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

class _Form extends StatelessWidget {
  const _Form();

  @override
  Widget build(BuildContext context) {
    final RunStatusType? runStatusType = context.select(
      (RunStatusCreatorBloc bloc) => bloc.state.runStatusType,
    );

    if (runStatusType == RunStatusType.done ||
        runStatusType == RunStatusType.aborted) {
      return const _FinishedWorkoutForm();
    }
    return const SizedBox();
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isFormValid = context.select(
      (RunStatusCreatorBloc bloc) => bloc.state.isFormValid,
    );
    final bool areDataSameAsOriginal = context.select(
      (RunStatusCreatorBloc bloc) => bloc.state.areDataSameAsOriginal,
    );

    return BigButton(
      label: Str.of(context).save,
      isDisabled: !isFormValid || areDataSameAsOriginal,
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  void _onPressed(BuildContext context) {
    context.read<RunStatusCreatorBloc>().add(
          const RunStatusCreatorEventSubmit(),
        );
  }
}
