import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/date_service.dart';
import '../../../domain/bloc/current_week/current_week_cubit.dart';
import '../../../domain/repository/race_repository.dart';
import 'current_week_content.dart';

@RoutePage()
class CurrentWeekScreen extends StatelessWidget {
  const CurrentWeekScreen({super.key});

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
        raceRepository: context.read<RaceRepository>(),
      )..initialize(),
      child: child,
    );
  }
}
