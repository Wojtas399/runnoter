import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/run_status_creator/run_status_creator_bloc.dart';
import '../../../domain/repository/race_repository.dart';
import '../../../domain/repository/workout_repository.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../service/dialog_service.dart';
import 'run_status_creator_content.dart';

@RoutePage()
class RunStatusCreatorScreen extends StatelessWidget {
  final String? entityType;
  final String? entityId;

  const RunStatusCreatorScreen({
    super.key,
    @PathParam('entityType') this.entityType,
    @PathParam('entityId') this.entityId,
  });

  @override
  Widget build(BuildContext context) {
    return _BlocProvider(
      entityType: entityType != null
          ? RunStatusCreatorEntityType.values.byName(entityType!)
          : null,
      entityId: entityId,
      child: const _BlocListener(
        child: RunStatusCreatorContent(),
      ),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final RunStatusCreatorEntityType? entityType;
  final String? entityId;
  final Widget child;

  const _BlocProvider({
    required this.entityType,
    required this.entityId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RunStatusCreatorBloc(
        workoutRepository: context.read<WorkoutRepository>(),
        raceRepository: context.read<RaceRepository>(),
        entityType: entityType,
        entityId: entityId,
      )..add(const RunStatusCreatorEventInitialize()),
      child: child,
    );
  }
}

class _BlocListener extends StatelessWidget {
  final Widget child;

  const _BlocListener({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocWithStatusListener<RunStatusCreatorBloc, RunStatusCreatorState,
        RunStatusCreatorBlocInfo, dynamic>(
      onInfo: (RunStatusCreatorBlocInfo info) => _manageInfo(context, info),
      child: child,
    );
  }

  void _manageInfo(BuildContext context, RunStatusCreatorBlocInfo info) {
    switch (info) {
      case RunStatusCreatorBlocInfo.runStatusSaved:
        context.back();
        showSnackbarMessage(Str.of(context).runStatusCreatorSavedStatusMessage);
        break;
    }
  }
}
