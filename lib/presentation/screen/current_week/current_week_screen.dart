import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../common/date_service.dart';
import '../../../domain/bloc/current_week/current_week_cubit.dart';
import '../../../domain/repository/race_repository.dart';
import '../../../domain/repository/workout_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/action_sheet_component.dart';
import '../../component/activity_item_component.dart';
import '../../component/loading_info_component.dart';
import '../../component/text/title_text_components.dart';
import '../../config/navigation/routes.dart';
import '../../formatter/date_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import '../screens.dart';

part 'current_week_add_activity_button.dart';
part 'current_week_content.dart';
part 'current_week_day_item.dart';

class CurrentWeekScreen extends StatelessWidget {
  const CurrentWeekScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _CubitProvider(
      child: CurrentWeekContent(),
    );
  }
}

class _CubitProvider extends StatelessWidget {
  final Widget child;

  const _CubitProvider({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CurrentWeekCubit(
        dateService: DateService(),
        authService: context.read<AuthService>(),
        workoutRepository: context.read<WorkoutRepository>(),
        raceRepository: context.read<RaceRepository>(),
      )..initialize(),
      child: child,
    );
  }
}
