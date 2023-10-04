import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/cubit/race_creator/race_creator_cubit.dart';
import '../../../component/cubit_with_status_listener_component.dart';
import '../../../component/page_not_found_component.dart';
import '../../../formatter/string_formatter.dart';
import '../../../service/dialog_service.dart';
import '../../../service/navigator_service.dart';
import 'race_creator_content.dart';

@RoutePage()
class RaceCreatorScreen extends StatelessWidget {
  final String? userId;
  final String? dateStr;
  final String? raceId;

  const RaceCreatorScreen({
    super.key,
    @PathParam('userId') this.userId,
    @PathParam('dateStr') this.dateStr,
    @PathParam('raceId') this.raceId,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime? date = dateStr?.toDateTime();

    return userId == null
        ? const PageNotFound()
        : BlocProvider(
            create: (_) => RaceCreatorCubit(userId: userId!, raceId: raceId)
              ..initialize(date),
            child: const _CubitListener(
              child: RaceCreatorContent(),
            ),
          );
  }
}

class _CubitListener extends StatefulWidget {
  final Widget child;

  const _CubitListener({required this.child});

  @override
  State<StatefulWidget> createState() => _CubitListenerState();
}

class _CubitListenerState extends State<_CubitListener> {
  @override
  Widget build(BuildContext context) {
    return CubitWithStatusListener<RaceCreatorCubit, RaceCreatorState,
        RaceCreatorCubitInfo, RaceCreatorCubitError>(
      onInfo: _manageInfo,
      onError: _manageError,
      child: widget.child,
    );
  }

  void _manageInfo(RaceCreatorCubitInfo info) {
    final str = Str.of(context);
    if (info == RaceCreatorCubitInfo.raceAdded) {
      navigateBack();
      showSnackbarMessage(str.raceCreatorAddedRaceMessage);
    } else if (info == RaceCreatorCubitInfo.raceUpdated) {
      navigateBack();
      showSnackbarMessage(str.raceCreatorUpdatedRaceMessage);
    }
  }

  Future<void> _manageError(RaceCreatorCubitError error) async {
    final str = Str.of(context);
    switch (error) {
      case RaceCreatorCubitError.raceNoLongerExists:
        await showMessageDialog(
          title: str.raceCreatorRaceNoLongerExistsDialogTitle,
          message: str.raceCreatorRaceNoLongerExistsDialogMessage,
        );
        if (mounted) {
          context.router.removeLast();
          context.router.removeLast();
        }
    }
  }
}
