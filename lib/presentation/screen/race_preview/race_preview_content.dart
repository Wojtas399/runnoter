import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/activity_status.dart';
import '../../../domain/cubit/activity_status_creator/activity_status_creator_cubit.dart';
import '../../../domain/cubit/race_preview/race_preview_cubit.dart';
import '../../component/big_button_component.dart';
import '../../component/body/medium_body_component.dart';
import '../../component/loading_info_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../config/navigation/router.dart';
import '../../extension/context_extensions.dart';
import '../../service/navigator_service.dart';
import 'race_preview_actions.dart';
import 'race_preview_race_info.dart';

class RacePreviewContent extends StatelessWidget {
  const RacePreviewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: _AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: MediumBody(
            child: Paddings24(
              child: Column(
                children: [
                  _RaceInfo(),
                  _RaceStatusButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(Str.of(context).racePreviewTitle),
      centerTitle: true,
      actions: [
        if (context.isMobileSize)
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: RacePreviewActions(),
          ),
      ],
    );
  }
}

class _RaceInfo extends StatelessWidget {
  const _RaceInfo();

  @override
  Widget build(BuildContext context) {
    final bool isRaceLoaded = context.select(
      (RacePreviewCubit cubit) => cubit.state.isRaceLoaded,
    );

    return isRaceLoaded ? const RacePreviewRaceInfo() : const LoadingInfo();
  }
}

class _RaceStatusButton extends StatelessWidget {
  const _RaceStatusButton();

  @override
  Widget build(BuildContext context) {
    final ActivityStatus? raceStatus = context.select(
      (RacePreviewCubit cubit) => cubit.state.raceStatus,
    );
    String label = Str.of(context).activityStatusEditStatus;
    if (raceStatus is ActivityStatusPending) {
      label = Str.of(context).activityStatusFinish;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: BigButton(
        label: label,
        onPressed: () => _onPressed(context),
      ),
    );
  }

  void _onPressed(BuildContext context) {
    final racePreviewCubit = context.read<RacePreviewCubit>();
    navigateTo(ActivityStatusCreatorRoute(
      userId: racePreviewCubit.userId,
      activityType: ActivityType.race.name,
      activityId: racePreviewCubit.raceId,
    ));
  }
}
