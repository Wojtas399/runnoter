part of 'competition_creator_screen.dart';

class _Form extends StatelessWidget {
  const _Form();

  @override
  Widget build(BuildContext context) {
    const Widget gap = SizedBox(height: 24);

    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CompetitionDate(),
        gap,
        _CompetitionName(),
        gap,
        _CompetitionPlace(),
        gap,
        _CompetitionDistance(),
        gap,
        _ExpectedDuration(),
      ],
    );
  }
}

class _CompetitionName extends StatelessWidget {
  const _CompetitionName();

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label: Str.of(context).competitionCreatorCompetitionName,
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
  const _CompetitionPlace();

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label: Str.of(context).competitionCreatorPlace,
      isRequired: true,
      maxLength: 100,
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
  const _CompetitionDistance();

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label: '${Str.of(context).competitionCreatorDistance} [km]',
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
