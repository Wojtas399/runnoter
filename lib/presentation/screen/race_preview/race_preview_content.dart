import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/activity_status.dart';
import '../../../domain/bloc/activity_status_creator/activity_status_creator_bloc.dart';
import '../../../domain/bloc/race_preview/race_preview_bloc.dart';
import '../../../domain/entity/race.dart';
import '../../component/big_button_component.dart';
import '../../component/body/medium_body_component.dart';
import '../../component/loading_info_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../config/navigation/router.dart';
import '../../extension/context_extensions.dart';
import '../../service/navigator_service.dart';
import 'race_preview_actions.dart';
import 'race_preview_race.dart';

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
    final Race? race = context.select(
      (RacePreviewBloc bloc) => bloc.state.race,
    );

    return race == null ? const LoadingInfo() : const RacePreviewRaceInfo();
  }
}

class _RaceStatusButton extends StatelessWidget {
  const _RaceStatusButton();

  @override
  Widget build(BuildContext context) {
    final bool canEditRaceStatus = context.select(
      (RacePreviewBloc bloc) => bloc.state.canEditRaceStatus,
    );
    final ActivityStatus? activityStatus = context.select(
      (RacePreviewBloc bloc) => bloc.state.race?.status,
    );
    String label = Str.of(context).activityStatusEditStatus;
    if (activityStatus is ActivityStatusPending) {
      label = Str.of(context).activityStatusFinish;
    }

    return canEditRaceStatus
        ? Padding(
            padding: const EdgeInsets.only(top: 32),
            child: BigButton(
              label: label,
              onPressed: () => _onPressed(context),
            ),
          )
        : const SizedBox();
  }

  void _onPressed(BuildContext context) {
    final String? raceId = context.read<RacePreviewBloc>().state.race?.id;
    if (raceId != null) {
      navigateTo(ActivityStatusCreatorRoute(
        entityType: ActivityStatusCreatorEntityType.race.name,
        entityId: raceId,
      ));
    }
  }
}
