import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/race_preview/race_preview_bloc.dart';
import '../../../domain/entity/run_status.dart';
import '../../../domain/repository/race_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/big_button_component.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/content_with_label_component.dart';
import '../../component/edit_delete_popup_menu_component.dart';
import '../../component/loading_info_component.dart';
import '../../component/nullable_text_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/run_stats_component.dart';
import '../../component/screen_adjustable_body_component.dart';
import '../../component/text/title_text_components.dart';
import '../../config/navigation/routes.dart';
import '../../extension/context_extensions.dart';
import '../../extension/double_extensions.dart';
import '../../extension/string_extensions.dart';
import '../../formatter/date_formatter.dart';
import '../../formatter/distance_unit_formatter.dart';
import '../../formatter/duration_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import '../race_creator/race_creator_screen.dart';
import '../run_status_creator/run_status_creator_screen.dart';

part 'race_preview_actions.dart';
part 'race_preview_content.dart';
part 'race_preview_race.dart';

class RacePreviewScreen extends StatelessWidget {
  final String raceId;

  const RacePreviewScreen({
    super.key,
    required this.raceId,
  });

  @override
  Widget build(BuildContext context) {
    return _BlocProvider(
      raceId: raceId,
      child: const _BlocListener(
        child: _Content(),
      ),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final String raceId;
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
      )..add(
          RacePreviewEventInitialize(
            raceId: raceId,
          ),
        ),
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
