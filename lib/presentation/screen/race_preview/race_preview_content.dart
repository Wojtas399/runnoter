import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/race_preview/race_preview_bloc.dart';
import '../../../domain/entity/race.dart';
import '../../component/body/medium_body_component.dart';
import '../../component/loading_info_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../extension/context_extensions.dart';
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
              child: _RaceInfo(),
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
