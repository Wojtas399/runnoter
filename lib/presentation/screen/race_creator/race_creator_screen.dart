import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/race_creator/race_creator_bloc.dart';
import '../../../domain/repository/race_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../extension/string_extensions.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import 'race_creator_content.dart';

@RoutePage()
class RaceCreatorScreen extends StatelessWidget {
  final String? dateStr;
  final String? raceId;

  const RaceCreatorScreen({
    super.key,
    @PathParam('dateStr') this.dateStr,
    @PathParam('raceId') this.raceId,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime? date = dateStr?.toDateTime();

    return _BlocProvider(
      raceId: raceId,
      date: date,
      child: const _BlocListener(
        child: RaceCreatorContent(),
      ),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final String? raceId;
  final DateTime? date;
  final Widget child;

  const _BlocProvider({
    required this.raceId,
    required this.date,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RaceCreatorBloc(
        raceId: raceId,
        authService: context.read<AuthService>(),
        raceRepository: context.read<RaceRepository>(),
      )..add(RaceCreatorEventInitialize(date: date)),
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
    return BlocWithStatusListener<RaceCreatorBloc, RaceCreatorState,
        RaceCreatorBlocInfo, dynamic>(
      onInfo: (RaceCreatorBlocInfo info) {
        _manageInfo(context, info);
      },
      child: child,
    );
  }

  void _manageInfo(BuildContext context, RaceCreatorBlocInfo info) {
    if (info == RaceCreatorBlocInfo.raceAdded) {
      navigateBack();
      showSnackbarMessage(Str.of(context).raceCreatorAddedRaceMessage);
    } else if (info == RaceCreatorBlocInfo.raceUpdated) {
      navigateBack();
      showSnackbarMessage(Str.of(context).raceCreatorUpdatedRaceMessage);
    }
  }
}
