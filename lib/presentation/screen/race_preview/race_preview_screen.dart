import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/race_preview/race_preview_bloc.dart';
import '../../../domain/repository/race_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import 'race_preview_content.dart';

@RoutePage()
class RacePreviewScreen extends StatelessWidget {
  final String? raceId;

  const RacePreviewScreen({
    super.key,
    @PathParam('raceId') this.raceId,
  });

  @override
  Widget build(BuildContext context) {
    return _BlocProvider(
      raceId: raceId,
      child: const _BlocListener(
        child: RacePreviewContent(),
      ),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final String? raceId;
  final Widget child;

  const _BlocProvider({
    required this.raceId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RacePreviewBloc(
        authService: context.read<AuthService>(),
        raceRepository: context.read<RaceRepository>(),
        raceId: raceId,
      )..add(const RacePreviewEventInitialize()),
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
    return BlocWithStatusListener<RacePreviewBloc, RacePreviewState,
        RacePreviewBlocInfo, dynamic>(
      onInfo: (RacePreviewBlocInfo info) {
        _manageInfo(context, info);
      },
      child: child,
    );
  }

  void _manageInfo(BuildContext context, RacePreviewBlocInfo info) {
    switch (info) {
      case RacePreviewBlocInfo.raceDeleted:
        navigateBack();
        showSnackbarMessage(Str.of(context).racePreviewDeletedRaceMessage);
    }
  }
}
