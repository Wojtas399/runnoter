import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../domain/entity/workout_stage.dart';
import '../../screen/screens.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HealthMeasurementsRoute.page),
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: WorkoutStageCreatorRoute.page),
        AutoRoute(page: WorkoutPreviewRoute.page),
        AutoRoute(page: ForgotPasswordRoute.page),
        AutoRoute(page: SignInRoute.page, initial: true),
        AutoRoute(page: BloodTestPreviewRoute.page),
        AutoRoute(page: RunStatusCreatorRoute.page),
        AutoRoute(page: RaceCreatorRoute.page),
        AutoRoute(page: BloodTestCreatorRoute.page),
        AutoRoute(page: RacePreviewRoute.page),
        AutoRoute(page: WorkoutCreatorRoute.page),
        AutoRoute(page: SignUpRoute.page),
      ];
}
