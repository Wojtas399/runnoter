part of 'health_measurement_creator_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bool confirmationToLeave = await askForConfirmationToLeave(
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
        body: const SafeArea(
          child: _Body(),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (HealthMeasurementCreatorBloc bloc) => bloc.state.status,
    );

    if (blocStatus is BlocStatusInitial) {
      return const LoadingInfo();
    }
    return const _Form();
  }
}
