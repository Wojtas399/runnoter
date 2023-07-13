part of 'workout_stage_creator_dialog.dart';

class _SeriesStageForm extends StatelessWidget {
  const _SeriesStageForm();

  @override
  Widget build(BuildContext context) {
    const Widget gap = SizedBox(height: 16);
    return const Column(
      children: [
        _AmountOfSeries(),
        gap,
        _SeriesDistance(),
        gap,
        _WalkingDistance(),
        gap,
        _JoggingDistance(),
      ],
    );
  }
}

class _AmountOfSeries extends StatefulWidget {
  const _AmountOfSeries();

  @override
  State<StatefulWidget> createState() => _AmountOfSeriesState();
}

class _AmountOfSeriesState extends State<_AmountOfSeries> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    final int? amountOfSeries =
        context.read<WorkoutStageCreatorBloc>().state.seriesForm.amountOfSeries;
    if (amountOfSeries != null) {
      _controller.text = amountOfSeries.toString();
    }
    _controller.addListener(_onChanged);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label: Str.of(context).workoutStageCreatorAmountOfSeries,
      keyboardType: TextInputType.number,
      maxLength: 2,
      isRequired: true,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      controller: _controller,
    );
  }

  void _onChanged() {
    int? amountOfSeries;
    if (_controller.text == '') {
      amountOfSeries = 0;
    } else {
      amountOfSeries = int.tryParse(_controller.text);
    }
    if (amountOfSeries != null) {
      context.read<WorkoutStageCreatorBloc>().add(
            WorkoutStageCreatorEventAmountOfSeriesChanged(
              amountOfSeries: amountOfSeries,
            ),
          );
    }
  }
}

class _SeriesDistance extends StatefulWidget {
  const _SeriesDistance();

  @override
  State<StatefulWidget> createState() => _SeriesDistanceState();
}

class _SeriesDistanceState extends State<_SeriesDistance> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    final int? seriesDistanceInMeters = context
        .read<WorkoutStageCreatorBloc>()
        .state
        .seriesForm
        .seriesDistanceInMeters;
    if (seriesDistanceInMeters != null) {
      _controller.text = seriesDistanceInMeters.toString();
    }
    _controller.addListener(_onChanged);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label: '${Str.of(context).workoutStageCreatorSeriesDistance} [m]',
      keyboardType: TextInputType.number,
      maxLength: 6,
      isRequired: true,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      controller: _controller,
    );
  }

  void _onChanged() {
    int? seriesDistance;
    if (_controller.text == '') {
      seriesDistance = 0;
    } else {
      seriesDistance = int.tryParse(_controller.text);
    }
    if (seriesDistance != null) {
      context.read<WorkoutStageCreatorBloc>().add(
            WorkoutStageCreatorEventSeriesDistanceChanged(
              seriesDistanceInMeters: seriesDistance,
            ),
          );
    }
  }
}

class _WalkingDistance extends StatefulWidget {
  const _WalkingDistance();

  @override
  State<StatefulWidget> createState() => _WalkingDistanceState();
}

class _WalkingDistanceState extends State<_WalkingDistance> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    final int? walkingDistanceInMeters = context
        .read<WorkoutStageCreatorBloc>()
        .state
        .seriesForm
        .walkingDistanceInMeters;
    if (walkingDistanceInMeters != null) {
      _controller.text = walkingDistanceInMeters.toString();
    }
    _controller.addListener(_onChanged);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label: '${Str.of(context).workoutStageCreatorWalkingDistance} [m]',
      keyboardType: TextInputType.number,
      maxLength: 6,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      controller: _controller,
    );
  }

  void _onChanged() {
    int? walkingDistance;
    if (_controller.text == '') {
      walkingDistance = 0;
    } else {
      walkingDistance = int.tryParse(_controller.text);
    }
    if (walkingDistance != null) {
      context.read<WorkoutStageCreatorBloc>().add(
            WorkoutStageCreatorEventWalkingDistanceChanged(
              walkingDistanceInMeters: walkingDistance,
            ),
          );
    }
  }
}

class _JoggingDistance extends StatefulWidget {
  const _JoggingDistance();

  @override
  State<StatefulWidget> createState() => _JoggingDistanceState();
}

class _JoggingDistanceState extends State<_JoggingDistance> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    final int? joggingDistanceInMeters = context
        .read<WorkoutStageCreatorBloc>()
        .state
        .seriesForm
        .joggingDistanceInMeters;
    if (joggingDistanceInMeters != null) {
      _controller.text = joggingDistanceInMeters.toString();
    }
    _controller.addListener(_onChanged);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label: '${Str.of(context).workoutStageCreatorJoggingDistance} [m]',
      keyboardType: TextInputType.number,
      maxLength: 6,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      controller: _controller,
    );
  }

  void _onChanged() {
    int? joggingDistance;
    if (_controller.text == '') {
      joggingDistance = 0;
    } else {
      joggingDistance = int.tryParse(_controller.text);
    }
    if (joggingDistance != null) {
      context.read<WorkoutStageCreatorBloc>().add(
            WorkoutStageCreatorEventJoggingDistanceChanged(
              joggingDistanceInMeters: joggingDistance,
            ),
          );
    }
  }
}
