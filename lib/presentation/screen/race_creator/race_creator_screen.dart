import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/cubit/race_creator/race_creator_cubit.dart';
import '../../component/cubit_with_status_listener_component.dart';
import '../../component/page_not_found_component.dart';
import '../../extension/string_extensions.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
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

class _CubitListener extends StatelessWidget {
  final Widget child;

  const _CubitListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return CubitWithStatusListener<RaceCreatorCubit, RaceCreatorState,
        RaceCreatorCubitInfo, dynamic>(
      onInfo: (RaceCreatorCubitInfo info) => _manageInfo(context, info),
      child: child,
    );
  }

  void _manageInfo(BuildContext context, RaceCreatorCubitInfo info) {
    if (info == RaceCreatorCubitInfo.raceAdded) {
      navigateBack();
      showSnackbarMessage(Str.of(context).raceCreatorAddedRaceMessage);
    } else if (info == RaceCreatorCubitInfo.raceUpdated) {
      navigateBack();
      showSnackbarMessage(Str.of(context).raceCreatorUpdatedRaceMessage);
    }
  }
}
