import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/bloc_status.dart';
import '../../../domain/bloc/race_creator/race_creator_bloc.dart';
import '../../../domain/repository/race_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/big_button_component.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/date_selector_component.dart';
import '../../component/duration_input_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/scrollable_content_component.dart';
import '../../component/text/title_text_components.dart';
import '../../component/text_field_component.dart';
import '../../extension/context_extensions.dart';
import '../../extension/double_extensions.dart';
import '../../extension/string_extensions.dart';
import '../../formatter/decimal_text_input_formatter.dart';
import '../../formatter/distance_unit_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import '../../service/utils.dart';

part 'race_creator_content.dart';
part 'race_creator_date.dart';
part 'race_creator_expected_duration.dart';
part 'race_creator_form.dart';

class RaceCreatorArguments {
  final String? raceId;
  final DateTime? date;

  RaceCreatorArguments({
    this.raceId,
    this.date,
  });
}

class RaceCreatorScreen extends StatelessWidget {
  final RaceCreatorArguments? arguments;

  const RaceCreatorScreen({
    super.key,
    this.arguments,
  });

  @override
  Widget build(BuildContext context) {
    return _BlocProvider(
      raceId: arguments?.raceId,
      date: arguments?.date,
      child: const _BlocListener(
        child: _Content(),
      ),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final String? raceId;
  final DateTime? date;
  final Widget child;

  const _BlocProvider({
    required this.raceId,
    required this.date,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RaceCreatorBloc(
        raceId: raceId,
        authService: context.read<AuthService>(),
        raceRepository: context.read<RaceRepository>(),
      )..add(
          RaceCreatorEventInitialize(date: date),
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
    return BlocWithStatusListener<RaceCreatorBloc, RaceCreatorState,
        RaceCreatorBlocInfo, dynamic>(
      onInfo: (RaceCreatorBlocInfo info) {
        _manageInfo(context, info);
      },
      child: child,
    );
  }

  void _manageInfo(BuildContext context, RaceCreatorBlocInfo info) {
    if (info == RaceCreatorBlocInfo.raceAdded) {
      navigateBack(context: context);
      showSnackbarMessage(
        context: context,
        message: Str.of(context).raceCreatorAddedRaceMessage,
      );
    } else if (info == RaceCreatorBlocInfo.raceUpdated) {
      navigateBack(context: context);
      showSnackbarMessage(
        context: context,
        message: Str.of(context).raceCreatorUpdatedRaceMessage,
      );
    }
  }
}
