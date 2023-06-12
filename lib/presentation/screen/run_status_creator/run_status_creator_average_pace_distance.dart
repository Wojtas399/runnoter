part of 'run_status_creator_screen.dart';

class _AveragePaceDistance extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (RunStatusCreatorBloc bloc) => bloc.state.status,
    );
    if (blocStatus is BlocStatusComplete &&
        blocStatus.info == RunStatusCreatorBlocInfo.runStatusInitialized) {
      final Pace? avgPace = context.read<RunStatusCreatorBloc>().state.avgPace;
      if (avgPace != null) {
        final ConvertedPace convertedPace = context.convertPaceFromDefaultUnit(
          avgPace,
        );
        if (convertedPace is ConvertedPaceDistance) {
          _controller.text = convertedPace.distance.toString();
        }
      }
    }

    return TextFieldComponent(
      label:
          '${Str.of(context).runStatusCreatorAveragePace} [${context.paceUnit.toUIFormat()}]',
      controller: _controller,
      keyboardType: TextInputType.number,
      maxLength: 5,
      inputFormatters: [
        DecimalTextInputFormatter(decimalRange: 2),
      ],
      onChanged: (String? value) {
        _onChanged(context, value);
      },
    );
  }

  void _onChanged(BuildContext context, String? value) {
    final double distance = double.tryParse(value ?? '') ?? 0;
    if (distance == 0) {
      const Pace pace = Pace(minutes: 0, seconds: 0);
      context.read<RunStatusCreatorBloc>().add(
            const RunStatusCreatorEventAvgPaceChanged(avgPace: pace),
          );
      return;
    }
    ConvertedPace? convertedPace;
    if (context.paceUnit == PaceUnit.kilometersPerHour) {
      convertedPace = ConvertedPaceKilometersPerHour(distance: distance);
    } else if (context.paceUnit == PaceUnit.milesPerHour) {
      convertedPace = ConvertedPaceMilesPerHour(distance: distance);
    }
    if (convertedPace != null) {
      final Pace pace = context.convertPaceToDefaultUnit(convertedPace);
      context.read<RunStatusCreatorBloc>().add(
            RunStatusCreatorEventAvgPaceChanged(avgPace: pace),
          );
    }
  }
}
