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
    required super.arguments,
  }) : super(path: RoutePath.dayPreview);
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
  profile('/home/profile'),
  themeMode('/home/profile/theme-mode'),
  language('/home/profile/language'),
  distanceUnit('/home/profile/distance-unit'),
  paceUnit('/home/profile/pace-unit');

  final String path;

  const RoutePath(this.path);
}
