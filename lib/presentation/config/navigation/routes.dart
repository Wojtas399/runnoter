import '../../screen/screens.dart';

abstract class CustomRoute {
  final RoutePath path;

  const CustomRoute({
    required this.path,
  });
}

abstract class CustomRouteWithArguments<T> extends CustomRoute {
  final T arguments;

  const CustomRouteWithArguments({
    required super.path,
    required this.arguments,
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

class WorkoutPreviewRoute extends CustomRouteWithArguments<String> {
  const WorkoutPreviewRoute({
    required String workoutId,
  }) : super(
          arguments: workoutId,
          path: RoutePath.workoutPreview,
        );
}

class WorkoutCreatorRoute
    extends CustomRouteWithArguments<WorkoutCreatorArguments> {
  const WorkoutCreatorRoute({
    required WorkoutCreatorArguments creatorArguments,
  }) : super(
          arguments: creatorArguments,
          path: RoutePath.workoutCreator,
        );
}

class RunStatusCreatorRoute
    extends CustomRouteWithArguments<RunStatusCreatorArguments> {
  const RunStatusCreatorRoute({
    required RunStatusCreatorArguments creatorArguments,
  }) : super(
          arguments: creatorArguments,
          path: RoutePath.runStatusCreator,
        );
}

class HealthMeasurementCreatorRoute
    extends CustomRouteWithArguments<DateTime?> {
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

class BloodTestCreatorRoute extends CustomRouteWithArguments<String?> {
  const BloodTestCreatorRoute({
    String? bloodTestId,
  }) : super(
          path: RoutePath.bloodTestCreator,
          arguments: bloodTestId,
        );
}

class BloodTestPreviewRoute extends CustomRouteWithArguments<String> {
  const BloodTestPreviewRoute({
    required String bloodTestId,
  }) : super(
          arguments: bloodTestId,
          path: RoutePath.bloodTestPreview,
        );
}

class CompetitionCreatorRoute extends CustomRouteWithArguments<String?> {
  const CompetitionCreatorRoute({
    String? competitionId,
  }) : super(
          arguments: competitionId,
          path: RoutePath.competitionCreator,
        );
}

class CompetitionPreviewRoute extends CustomRouteWithArguments<String> {
  const CompetitionPreviewRoute({
    required String competitionId,
  }) : super(
          arguments: competitionId,
          path: RoutePath.competitionPreview,
        );
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
  workoutPreview('/home/workout-preview'),
  workoutCreator('/home/day-preview/workout-creator'),
  runStatusCreator('/home/day-preview/workout-status-creator'),
  healthMeasurementCreator('/home/health_measurement-creator'),
  healthMeasurements('/home/health-measurements'),
  bloodTestCreator('/home/blood-test-creator'),
  bloodTestPreview('/home/blood-test-preview'),
  competitionCreator('/home/competition-creator'),
  competitionPreview('/home/competition-preview'),
  themeMode('/home/profile/theme-mode'),
  language('/home/profile/language'),
  distanceUnit('/home/profile/distance-unit'),
  paceUnit('/home/profile/pace-unit');

  final String path;

  const RoutePath(this.path);
}
