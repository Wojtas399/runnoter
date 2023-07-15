part of 'health_measurement_creator_dialog.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) => context.isMobileSize
      ? const _FullScreenDialogContent()
      : const _NormalDialogContent();
}

class _NormalDialogContent extends StatelessWidget {
  const _NormalDialogContent();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    return AlertDialog(
      title: Text(str.healthMeasurementCreatorScreenTitle),
      content: GestureDetector(
        onTap: unfocusInputs,
        child: const SizedBox(
          width: mediumContentWidth,
          child: _Body(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: popRoute,
          child: LabelLarge(
            str.cancel,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        const _SubmitButton(),
      ],
    );
  }
}

class _FullScreenDialogContent extends StatelessWidget {
  const _FullScreenDialogContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Str.of(context).healthMeasurementCreatorScreenTitle),
        leading: const CloseButton(),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: unfocusInputs,
          child: const Paddings24(
            child: _Body(),
          ),
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
