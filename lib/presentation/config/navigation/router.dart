import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../screen/home/home_base.dart';
import '../../screen/screens.dart';

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
          children: [
            AutoRoute(
              page: HomeRoute.page,
              path: '',
              children: [
                RedirectRoute(path: '', redirectTo: 'current-week'),
                AutoRoute(
                  page: CurrentWeekRoute.page,
                  path: 'current-week',
                  title: (context, _) => Str.of(context).currentWeekTitle,
                ),
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
              ],
            ),
            AutoRoute(
              page: WorkoutPreviewRoute.page,
              path: 'workout-preview/:workoutId',
            ),
            AutoRoute(
              page: WorkoutCreatorRoute.page,
              path: 'workout-creator/:date/:workoutId',
            ),
            AutoRoute(
              page: RacePreviewRoute.page,
              path: 'race-preview',
            ),
            AutoRoute(
              page: RaceCreatorRoute.page,
              path: 'race-creator',
            ),
            AutoRoute(
              page: HealthMeasurementsRoute.page,
              path: 'health-measurements',
            ),
            AutoRoute(
              page: BloodTestCreatorRoute.page,
              path: 'blood-test-creator',
            ),
            AutoRoute(
              page: BloodTestPreviewRoute.page,
              path: 'blood-test-preview',
            ),
            AutoRoute(
              page: RacePreviewRoute.page,
              path: 'race-preview',
            ),
            AutoRoute(
              page: RaceCreatorRoute.page,
              path: 'race-creator',
            ),
          ],
        ),
      ];
}
