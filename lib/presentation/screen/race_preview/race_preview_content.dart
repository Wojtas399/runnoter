import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/race_preview/race_preview_bloc.dart';
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
    return Scaffold(
      appBar: const _AppBar(),
      body: SafeArea(
        child: MediumBody(
          child: Paddings24(
            child: BlocSelector<RacePreviewBloc, RacePreviewState, bool>(
              selector: (state) => state.race != null,
              builder: (_, bool isRaceLoaded) => isRaceLoaded
                  ? const RacePreviewRaceInfo()
                  : const LoadingInfo(),
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
