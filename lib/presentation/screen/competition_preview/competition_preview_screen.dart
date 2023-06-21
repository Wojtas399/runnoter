import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/competition_preview/competition_preview_bloc.dart';
import '../../../domain/entity/run_status.dart';
import '../../../domain/repository/competition_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/big_button_component.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/content_with_label_component.dart';
import '../../component/edit_delete_popup_menu_component.dart';
import '../../component/nullable_text_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/run_stats_component.dart';
import '../../component/text/title_text_components.dart';
import '../../config/navigation/routes.dart';
import '../../extension/context_extensions.dart';
import '../../extension/double_extensions.dart';
import '../../extension/string_extensions.dart';
import '../../formatter/date_formatter.dart';
import '../../formatter/distance_unit_formatter.dart';
import '../../formatter/duration_formatter.dart';
import '../../formatter/run_status_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import '../run_status_creator/run_status_creator_screen.dart';

part 'competition_preview_app_bar.dart';
part 'competition_preview_content.dart';

class CompetitionPreviewScreen extends StatelessWidget {
  final String competitionId;

  const CompetitionPreviewScreen({
    super.key,
    required this.competitionId,
  });

  @override
  Widget build(BuildContext context) {
    return _BlocProvider(
      competitionId: competitionId,
      child: const _BlocListener(
        child: _Content(),
      ),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final String competitionId;
  final Widget child;

  const _BlocProvider({
    required this.competitionId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CompetitionPreviewBloc(
        authService: context.read<AuthService>(),
        competitionRepository: context.read<CompetitionRepository>(),
      )..add(
          CompetitionPreviewEventInitialize(
            competitionId: competitionId,
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
    return BlocWithStatusListener<CompetitionPreviewBloc,
        CompetitionPreviewState, CompetitionPreviewBlocInfo, dynamic>(
      onInfo: (CompetitionPreviewBlocInfo info) {
        _manageInfo(context, info);
      },
      child: child,
    );
  }

  void _manageInfo(BuildContext context, CompetitionPreviewBlocInfo info) {
    switch (info) {
      case CompetitionPreviewBlocInfo.competitionDeleted:
        navigateBack(context: context);
        showSnackbarMessage(
          context: context,
          message: Str.of(context).competitionPreviewDeletedCompetitionMessage,
        );
    }
  }
}
