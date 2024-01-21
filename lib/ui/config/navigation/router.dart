import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../screen/home/home_base.dart';
import '../../screen/screens.dart';
import '../guards/auth_guard.dart';
import '../guards/blood_test_guard.dart';
import '../guards/client_guard.dart';
import '../guards/race_guard.dart';
import '../guards/workout_guard.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SignInRoute.page,
          path: '/',
        ),
        AutoRoute(
          page: SignUpRoute.page,
          path: '/sign-up',
        ),
        AutoRoute(
          page: ForgotPasswordRoute.page,
          path: '/forgot-password',
        ),
        AutoRoute(
          page: HomeBaseRoute.page,
          path: '/home',
          guards: [AuthGuard()],
          children: [
            AutoRoute(
              page: HomeRoute.page,
              path: '',
              children: [
                RedirectRoute(path: '', redirectTo: 'calendar'),
                AutoRoute(
                  page: CalendarRoute.page,
                  path: 'calendar',
                  title: (context, _) => Str.of(context).calendarTitle,
                ),
                AutoRoute(
                  page: HealthRoute.page,
                  path: 'health',
                  title: (context, _) => Str.of(context).healthTitle,
                ),
                AutoRoute(
                  page: MileageRoute.page,
                  path: 'mileage',
                  title: (context, _) => Str.of(context).mileageTitle,
                ),
                AutoRoute(
                  page: BloodTestsRoute.page,
                  path: 'blood-tests',
                  title: (context, _) => Str.of(context).bloodTestsTitle,
                ),
                AutoRoute(
                  page: RacesRoute.page,
                  path: 'races',
                  title: (context, _) => Str.of(context).racesTitle,
                ),
                AutoRoute(
                  page: ProfileRoute.page,
                  path: 'profile',
                  title: (context, _) => Str.of(context).profileTitle,
                ),
                AutoRoute(
                  page: ClientsRoute.page,
                  path: 'clients',
                  title: (context, _) => Str.of(context).clientsTitle,
                ),
              ],
            ),
            AutoRoute(
              page: WorkoutPreviewRoute.page,
              path: 'workout-preview/:userId/:workoutId',
              guards: [WorkoutGuard()],
            ),
            AutoRoute(
              page: WorkoutCreatorRoute.page,
              path: 'workout-creator/:userId/:dateStr/:workoutId',
            ),
            AutoRoute(
              page: RacePreviewRoute.page,
              path: 'race-preview/:userId/:raceId',
              guards: [RaceGuard()],
            ),
            AutoRoute(
              page: RaceCreatorRoute.page,
              path: 'race-creator/:userId/:dateStr/:raceId',
            ),
            AutoRoute(
              page: HealthMeasurementsRoute.page,
              path: 'health-measurements',
            ),
            AutoRoute(
              page: BloodTestCreatorRoute.page,
              path: 'blood-test-creator/:userId/:bloodTestId',
            ),
            AutoRoute(
              page: BloodTestPreviewRoute.page,
              path: 'blood-test-preview/:userId/:bloodTestId',
              guards: [BloodTestGuard()],
            ),
            AutoRoute(
              page: ActivityStatusCreatorRoute.page,
              path: 'activity-status-creator/:userId/:activityType/:activityId',
            ),
            AutoRoute(
              page: ChatRoute.page,
              path: 'chat/:chatId',
            ),
            AutoRoute(
              page: ClientRoute.page,
              path: 'client/:clientId',
              guards: [ClientGuard()],
              children: [
                RedirectRoute(path: '', redirectTo: 'calendar'),
                AutoRoute(
                  page: ClientCalendarRoute.page,
                  path: 'calendar',
                ),
                AutoRoute(
                  page: ClientStatsRoute.page,
                  path: 'statistics',
                ),
                AutoRoute(
                  page: ClientRacesRoute.page,
                  path: 'races',
                ),
                AutoRoute(
                  page: ClientBloodTestsRoute.page,
                  path: 'blood-tests',
                ),
              ],
            ),
          ],
        ),
      ];
}
