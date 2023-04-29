import '../../screen/workout_creator/ui/workout_creator_screen.dart';

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

class WorkoutStatusCreatorRoute extends CustomRoute<String> {
  const WorkoutStatusCreatorRoute({
    required String workoutId,
  }) : super(
          arguments: workoutId,
          path: RoutePath.workoutStatusCreator,
        );
}

class ProfileRoute extends CustomRoute {
  const ProfileRoute() : super(path: RoutePath.profile);
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
  profile('/home/profile'),
  themeMode('/home/profile/theme-mode'),
  language('/home/profile/language'),
  distanceUnit('/home/profile/distance-unit'),
  paceUnit('/home/profile/pace-unit');

  final String path;

  const RoutePath(this.path);
}
