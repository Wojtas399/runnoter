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

class RaceCreatorRoute extends CustomRouteWithArguments<RaceCreatorArguments?> {
  const RaceCreatorRoute({
    RaceCreatorArguments? arguments,
  }) : super(
          arguments: arguments,
          path: RoutePath.raceCreator,
        );
}

class RacePreviewRoute extends CustomRouteWithArguments<String> {
  const RacePreviewRoute({
    required String raceId,
  }) : super(
          arguments: raceId,
          path: RoutePath.racePreview,
        );
}

enum RoutePath {
  signIn('/'),
  signUp('/sign-up'),
  forgotPassword('/forgot-password'),
  home('/home'),
  workoutPreview('/home/workout-preview'),
  workoutCreator('/home/workout-creator'),
  runStatusCreator('/home/workout-preview/workout-status-creator'),
  healthMeasurements('/home/health-measurements'),
  bloodTestCreator('/home/blood-test-creator'),
  bloodTestPreview('/home/blood-test-preview'),
  raceCreator('/home/race-creator'),
  racePreview('/home/race-preview');

  final String path;

  const RoutePath(this.path);
}
