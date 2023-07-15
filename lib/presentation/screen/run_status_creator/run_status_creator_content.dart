part of 'run_status_creator_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bool confirmationToLeave = await askForConfirmationToLeave(
          areUnsavedChanges:
              context.read<RunStatusCreatorBloc>().state.canSubmit,
        );
        if (confirmationToLeave) unfocusInputs();
        return confirmationToLeave;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(Str.of(context).runStatusCreatorScreenTitle),
          centerTitle: true,
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: unfocusInputs,
            child: ScrollableContent(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: bigContentWidth,
                      ),
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
                  ],
                ),
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
      return const _ParamsForm();
    }
    return const SizedBox();
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (RunStatusCreatorBloc bloc) => !bloc.state.canSubmit,
    );

    return BigButton(
      label: Str.of(context).save,
      isDisabled: isDisabled,
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
