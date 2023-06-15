part of 'health_measurement_creator_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bool confirmationToLeave = await askForConfirmationToLeave(
          context: context,
          areUnsavedChanges:
              context.read<HealthMeasurementCreatorBloc>().state.canSubmit,
        );
        if (confirmationToLeave) unfocusInputs();
        return confirmationToLeave;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            Str.of(context).healthMeasurementCreatorScreenTitle,
          ),
        ),
        body: SafeArea(
          child: BlocSelector<HealthMeasurementCreatorBloc,
              HealthMeasurementCreatorState, BlocStatus>(
            selector: (state) => state.status,
            builder: (_, BlocStatus blocStatus) {
              if (blocStatus is BlocStatusInitial) {
                return const _LoadingContent();
              }
              return const _FormContent();
            },
          ),
        ),
      ),
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _FormContent extends StatelessWidget {
  const _FormContent();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: unfocusInputs,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(24),
        child: _Form(),
      ),
    );
  }
}
