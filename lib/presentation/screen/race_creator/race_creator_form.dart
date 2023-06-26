part of 'race_creator_screen.dart';

class _Form extends StatelessWidget {
  const _Form();

  @override
  Widget build(BuildContext context) {
    const Widget gap = SizedBox(height: 24);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _RaceDate(),
        gap,
        _RaceName(),
        gap,
        _RacePlace(),
        gap,
        _RaceDistance(),
        gap,
        const _ExpectedDuration(),
      ],
    );
  }
}

class _RaceName extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (RaceCreatorBloc bloc) => bloc.state.status,
    );
    final String? name = context.select(
      (RaceCreatorBloc bloc) => bloc.state.name,
    );

    if (blocStatus is BlocStatusComplete &&
        blocStatus.info == RaceCreatorBlocInfo.editModeInitialized) {
      _controller.text = name ?? '';
    }

    return TextFieldComponent(
      label: Str.of(context).raceName,
      controller: _controller,
      isRequired: true,
      maxLength: 100,
      onChanged: (String? value) {
        _onChanged(context, value);
      },
    );
  }

  void _onChanged(BuildContext context, String? value) {
    context.read<RaceCreatorBloc>().add(
          RaceCreatorEventNameChanged(name: value),
        );
  }
}

class _RacePlace extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (RaceCreatorBloc bloc) => bloc.state.status,
    );
    final String? place = context.select(
      (RaceCreatorBloc bloc) => bloc.state.place,
    );

    if (blocStatus is BlocStatusComplete &&
        blocStatus.info == RaceCreatorBlocInfo.editModeInitialized) {
      _controller.text = place ?? '';
    }

    return TextFieldComponent(
      label: Str.of(context).racePlace,
      isRequired: true,
      maxLength: 100,
      controller: _controller,
      onChanged: (String? value) {
        _onChanged(context, value);
      },
    );
  }

  void _onChanged(BuildContext context, String? value) {
    context.read<RaceCreatorBloc>().add(
          RaceCreatorEventPlaceChanged(place: value),
        );
  }
}

class _RaceDistance extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (RaceCreatorBloc bloc) => bloc.state.status,
    );
    final double? distance = context.select(
      (RaceCreatorBloc bloc) => bloc.state.distance,
    );

    if (blocStatus is BlocStatusComplete &&
        blocStatus.info == RaceCreatorBlocInfo.editModeInitialized) {
      String? distanceStr;
      if (distance != null) {
        distanceStr = context
            .convertDistanceFromDefaultUnit(distance)
            .decimal(2)
            .toString()
            .trimZeros();
      }
      _controller.text = distanceStr ?? '';
    }

    return TextFieldComponent(
      label:
          '${Str.of(context).raceDistance} [${context.distanceUnit.toUIShortFormat()}]',
      controller: _controller,
      isRequired: true,
      maxLength: 7,
      inputFormatters: [
        DecimalTextInputFormatter(decimalRange: 3),
      ],
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (String? value) {
        _onChanged(context, value);
      },
    );
  }

  void _onChanged(BuildContext context, String? valueStr) {
    double? distance;
    if (valueStr != null) {
      distance = double.tryParse(valueStr);
    }
    context.read<RaceCreatorBloc>().add(
          RaceCreatorEventDistanceChanged(
            distance: distance != null
                ? context.convertDistanceToDefaultUnit(distance)
                : 0,
          ),
        );
  }
}
