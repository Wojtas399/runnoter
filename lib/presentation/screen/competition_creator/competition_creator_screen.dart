import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/bloc_status.dart';
import '../../../domain/bloc/competition_creator/competition_creator_bloc.dart';
import '../../../domain/repository/competition_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/big_button_component.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/duration_input_component.dart';
import '../../component/scrollable_content_component.dart';
import '../../component/text/title_text_components.dart';
import '../../component/text_field_component.dart';
import '../../formatter/date_formatter.dart';
import '../../formatter/decimal_text_input_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import '../../service/utils.dart';

part 'competition_creator_content.dart';
part 'competition_creator_date.dart';
part 'competition_creator_expected_duration.dart';
part 'competition_creator_form.dart';

class CompetitionCreatorScreen extends StatelessWidget {
  final String? competitionId;

  const CompetitionCreatorScreen({
    super.key,
    this.competitionId,
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
  final String? competitionId;
  final Widget child;

  const _BlocProvider({
    required this.competitionId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CompetitionCreatorBloc(
        authService: context.read<AuthService>(),
        competitionRepository: context.read<CompetitionRepository>(),
      )..add(
          CompetitionCreatorEventInitialize(competitionId: competitionId),
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
    return BlocWithStatusListener<CompetitionCreatorBloc,
        CompetitionCreatorState, CompetitionCreatorBlocInfo, dynamic>(
      onInfo: (CompetitionCreatorBlocInfo info) {
        _manageInfo(context, info);
      },
      child: child,
    );
  }

  void _manageInfo(BuildContext context, CompetitionCreatorBlocInfo info) {
    if (info == CompetitionCreatorBlocInfo.competitionAdded) {
      navigateBack(context: context);
      showSnackbarMessage(
        context: context,
        message: Str.of(context).competitionCreatorAddedCompetitionMessage,
      );
    } else if (info == CompetitionCreatorBlocInfo.competitionUpdated) {
      navigateBack(context: context);
      showSnackbarMessage(
        context: context,
        message: 'Pomyślnie zaktualizowano zawody',
      );
    }
  }
}
