import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/bloc_status.dart';
import '../../../domain/bloc/race_creator/race_creator_bloc.dart';
import '../../component/duration_input_component.dart';

class RaceCreatorExpectedDuration extends StatelessWidget {
  const RaceCreatorExpectedDuration({super.key});

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
            onDurationChanged: (Duration duration) {
              _onChanged(context, duration);
            },
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
