import '../../screen/screens.dart';

abstract class CustomRoute<T> {
  final RoutePath path;
  final T? arguments;

  const CustomRoute({
    required this.path,
    this.arguments,
  });
}

class SignInRoute extends CustomRoute {
  const SignInRoute() : super(path: RoutePath.signIn);
}

class SignUpRoute extends CustomRoute {
  const SignUpRoute() : super(path: RoutePath.signUp);
}

class ForgotPasswordRoute extends CustomRoute {
  const ForgotPasswordRoute() : super(path: RoutePath.forgotPassword);
}

class HomeRoute extends CustomRoute {
  const HomeRoute() : super(path: RoutePath.home);
}

class DayPreviewRoute extends CustomRoute<DateTime> {
  const DayPreviewRoute({
    required DateTime date,
  }) : super(
          arguments: date,
          path: RoutePath.dayPreview,
        );
}

class WorkoutCreatorRoute extends CustomRoute<WorkoutCreatorArguments> {
  const WorkoutCreatorRoute({
    required WorkoutCreatorArguments creatorArguments,
  }) : super(
          arguments: creatorArguments,
          path: RoutePath.workoutCreator,
        );
}

class WorkoutStatusCreatorRoute
    extends CustomRoute<WorkoutStatusCreatorArguments> {
  const WorkoutStatusCreatorRoute({
    required WorkoutStatusCreatorArguments creatorArguments,
  }) : super(
          arguments: creatorArguments,
          path: RoutePath.workoutStatusCreator,
        );
}

class HealthMeasurementCreatorRoute extends CustomRoute<DateTime?> {
  const HealthMeasurementCreatorRoute({
    DateTime? date,
  }) : super(
          arguments: date,
          path: RoutePath.healthMeasurementCreator,
        );
}

class HealthMeasurementsRoute extends CustomRoute {
  const HealthMeasurementsRoute() : super(path: RoutePath.healthMeasurements);
}

class BloodTestCreatorRoute extends CustomRoute {
  const BloodTestCreatorRoute() : super(path: RoutePath.bloodTestCreator);
}

class ThemeModeRoute extends CustomRoute {
  const ThemeModeRoute() : super(path: RoutePath.themeMode);
}

class LanguageRoute extends CustomRoute {
  const LanguageRoute() : super(path: RoutePath.language);
}

class DistanceUnitRoute extends CustomRoute {
  const DistanceUnitRoute() : super(path: RoutePath.distanceUnit);
}

class PaceUnitRoute extends CustomRoute {
  const PaceUnitRoute() : super(path: RoutePath.paceUnit);
}

enum RoutePath {
  signIn('/'),
  signUp('/sign-up'),
  forgotPassword('/forgot-password'),
  home('/home'),
  dayPreview('/home/day-preview'),
  workoutCreator('/home/day-preview/workout-creator'),
  workoutStatusCreator('/home/day-preview/workout-status-creator'),
  healthMeasurementCreator('/home/health_measurement-creator'),
  healthMeasurements('/home/health-measurements'),
  bloodTestCreator('/home/blood-test-creator'),
  themeMode('/home/profile/theme-mode'),
  language('/home/profile/language'),
  distanceUnit('/home/profile/distance-unit'),
  paceUnit('/home/profile/pace-unit');

  final String path;

  const RoutePath(this.path);
}
