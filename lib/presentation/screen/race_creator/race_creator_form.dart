import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/bloc_status.dart';
import '../../../domain/bloc/race_creator/race_creator_bloc.dart';
import '../../component/duration_input_component.dart';
import '../../component/form_text_field_component.dart';
import '../../component/gap/gap_components.dart';
import '../../extension/context_extensions.dart';
import '../../extension/double_extensions.dart';
import '../../extension/string_extensions.dart';
import '../../formatter/decimal_text_input_formatter.dart';
import '../../formatter/distance_unit_formatter.dart';
import '../../service/utils.dart';
import 'race_creator_date.dart';

class RaceCreatorForm extends StatelessWidget {
  const RaceCreatorForm({super.key});

  @override
  Widget build(BuildContext context) {
    const Widget gap = Gap24();

    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RaceCreatorDate(),
        gap,
        _RaceName(),
        gap,
        _RacePlace(),
        gap,
        _RaceDistance(),
        gap,
        _ExpectedDuration(),
      ],
    );
  }
}

class _RaceName extends StatefulWidget {
  const _RaceName();

  @override
  State<StatefulWidget> createState() => _RaceNameState();
}

class _RaceNameState extends State<_RaceName> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    final String? name = context.read<RaceCreatorBloc>().state.name;
    if (name != null) _controller.text = name;
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
    return FormTextField(
      label: Str.of(context).raceName,
      controller: _controller,
      isRequired: true,
      maxLength: 100,
      maxLines: 1,
      onTapOutside: (_) => unfocusInputs(),
      onSubmitted: (_) => _onSubmitted(context),
    );
  }

  void _onChanged() {
    context.read<RaceCreatorBloc>().add(
          RaceCreatorEventNameChanged(name: _controller.text),
        );
  }
}

class _RacePlace extends StatefulWidget {
  const _RacePlace();

  @override
  State<StatefulWidget> createState() => _RacePlaceState();
}

class _RacePlaceState extends State<_RacePlace> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    final String? place = context.read<RaceCreatorBloc>().state.place;
    if (place != null) _controller.text = place;
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
    return FormTextField(
      label: Str.of(context).racePlace,
      isRequired: true,
      maxLength: 100,
      maxLines: 1,
      controller: _controller,
      onSubmitted: (_) => _onSubmitted(context),
    );
  }

  void _onChanged() {
    context.read<RaceCreatorBloc>().add(
          RaceCreatorEventPlaceChanged(place: _controller.text),
        );
  }
}

class _RaceDistance extends StatefulWidget {
  const _RaceDistance();

  @override
  State<StatefulWidget> createState() => _RaceDistanceState();
}

class _RaceDistanceState extends State<_RaceDistance> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    final double? distance = context.read<RaceCreatorBloc>().state.distance;
    if (distance != null) {
      _controller.text = context
          .convertDistanceFromDefaultUnit(distance)
          .decimal(2)
          .toString()
          .trimZeros();
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
    return FormTextField(
      label:
          '${Str.of(context).raceDistance} [${context.distanceUnit.toUIShortFormat()}]',
      controller: _controller,
      isRequired: true,
      maxLength: 7,
      maxLines: 1,
      inputFormatters: [
        DecimalTextInputFormatter(decimalRange: 3),
      ],
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onSubmitted: (_) => _onSubmitted(context),
    );
  }

  void _onChanged() {
    final double? distance = double.tryParse(_controller.text);
    context.read<RaceCreatorBloc>().add(
          RaceCreatorEventDistanceChanged(
            distance: distance != null
                ? context.convertDistanceToDefaultUnit(distance)
                : 0,
          ),
        );
  }
}

class _ExpectedDuration extends StatelessWidget {
  const _ExpectedDuration();

  @override
  Widget build(BuildContext context) {
    final Duration? duration = context.select(
      (RaceCreatorBloc bloc) => bloc.state.expectedDuration,
    );
    final BlocStatus? blocStatus = context.select(
      (RaceCreatorBloc bloc) => bloc.state.status,
    );

    return blocStatus is BlocStatusInitial
        ? const SizedBox()
        : DurationInput(
            label: Str.of(context).raceExpectedDuration,
            initialDuration: duration,
            onDurationChanged: (Duration duration) =>
                _onChanged(context, duration),
            onSubmitted: () => _onSubmitted(context),
          );
  }

  void _onChanged(BuildContext context, Duration duration) {
    context.read<RaceCreatorBloc>().add(
          RaceCreatorEventExpectedDurationChanged(
            expectedDuration: duration,
          ),
        );
  }
}

void _onSubmitted(BuildContext context) {
  final bloc = context.read<RaceCreatorBloc>();
  if (bloc.state.canSubmit) {
    bloc.add(const RaceCreatorEventSubmit());
  }
}
