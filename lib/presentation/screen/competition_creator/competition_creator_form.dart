part of 'competition_creator_screen.dart';

class _Form extends StatelessWidget {
  const _Form();

  @override
  Widget build(BuildContext context) {
    const Widget gap = SizedBox(height: 24);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _CompetitionDate(),
        gap,
        _CompetitionName(),
        gap,
        _CompetitionPlace(),
        gap,
        _CompetitionDistance(),
        gap,
        const _ExpectedDuration(),
      ],
    );
  }
}

class _CompetitionName extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (CompetitionCreatorBloc bloc) => bloc.state.status,
    );
    final String? name = context.select(
      (CompetitionCreatorBloc bloc) => bloc.state.name,
    );

    if (blocStatus is BlocStatusComplete &&
        blocStatus.info == CompetitionCreatorBlocInfo.editModeInitialized) {
      _controller.text = name ?? '';
    }

    return TextFieldComponent(
      label: Str.of(context).competitionName,
      controller: _controller,
      isRequired: true,
      maxLength: 100,
      onChanged: (String? value) {
        _onChanged(context, value);
      },
    );
  }

  void _onChanged(BuildContext context, String? value) {
    context.read<CompetitionCreatorBloc>().add(
          CompetitionCreatorEventNameChanged(name: value),
        );
  }
}

class _CompetitionPlace extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (CompetitionCreatorBloc bloc) => bloc.state.status,
    );
    final String? place = context.select(
      (CompetitionCreatorBloc bloc) => bloc.state.place,
    );

    if (blocStatus is BlocStatusComplete &&
        blocStatus.info == CompetitionCreatorBlocInfo.editModeInitialized) {
      _controller.text = place ?? '';
    }

    return TextFieldComponent(
      label: Str.of(context).competitionPlace,
      isRequired: true,
      maxLength: 100,
      controller: _controller,
      onChanged: (String? value) {
        _onChanged(context, value);
      },
    );
  }

  void _onChanged(BuildContext context, String? value) {
    context.read<CompetitionCreatorBloc>().add(
          CompetitionCreatorEventPlaceChanged(place: value),
        );
  }
}

class _CompetitionDistance extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (CompetitionCreatorBloc bloc) => bloc.state.status,
    );
    final double? distance = context.select(
      (CompetitionCreatorBloc bloc) => bloc.state.distance,
    );

    if (blocStatus is BlocStatusComplete &&
        blocStatus.info == CompetitionCreatorBlocInfo.editModeInitialized) {
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
          '${Str.of(context).competitionDistance} [${context.distanceUnit.toUIShortFormat()}]',
      controller: _controller,
      isRequired: true,
      maxLength: 7,
      inputFormatters: [
        DecimalTextInputFormatter(decimalRange: 3),
      ],
      keyboardType: TextInputType.number,
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
    context.read<CompetitionCreatorBloc>().add(
          CompetitionCreatorEventDistanceChanged(
            distance: distance ?? 0,
          ),
        );
  }
}
