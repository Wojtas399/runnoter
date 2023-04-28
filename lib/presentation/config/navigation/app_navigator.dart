import 'package:flutter/material.dart';

import '../../screen/day_preview/ui/day_preview_screen.dart';
import '../../screen/distance_unit/distance_unit_screen.dart';
import '../../screen/forgot_password/ui/forgot_password_screen.dart';
import '../../screen/home/ui/home_screen.dart';
import '../../screen/language/language_screen.dart';
import '../../screen/pace_unit/pace_unit_screen.dart';
import '../../screen/profile/ui/profile_screen.dart';
import '../../screen/sign_in/ui/sign_in_screen.dart';
import '../../screen/sign_up/ui/sign_up_screen.dart';
import '../../screen/theme_mode/theme_mode_screen.dart';
import '../../screen/workout_creator/ui/workout_creator_screen.dart';
import '../animation/slide_to_top_anim.dart';
import 'routes.dart';

class AppNavigator extends StatelessWidget {
  const AppNavigator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: RoutePath.signIn.path,
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    final String? routePath = settings.name;
    bool isSlideToTopAnim = false;
    Widget screen = const SignInScreen();
    if (routePath == RoutePath.signIn.path) {
      screen = const SignInScreen();
    } else if (routePath == RoutePath.signUp.path) {
      screen = const SignUpScreen();
    } else if (routePath == RoutePath.forgotPassword.path) {
      screen = const ForgotPasswordScreen();
    } else if (routePath == RoutePath.home.path) {
      screen = const HomeScreen();
    } else if (routePath == RoutePath.dayPreview.path) {
      screen = DayPreviewScreen(
        date: settings.arguments as DateTime,
      );
    } else if (routePath == RoutePath.workoutCreator.path) {
      screen = WorkoutCreatorScreen(
        arguments: settings.arguments as WorkoutCreatorArguments,
      );
    } else if (routePath == RoutePath.profile.path) {
      screen = const ProfileScreen();
    } else if (routePath == RoutePath.themeMode.path) {
      screen = const ThemeModeScreen();
      isSlideToTopAnim = true;
    } else if (routePath == RoutePath.language.path) {
      screen = const LanguageScreen();
      isSlideToTopAnim = true;
    } else if (routePath == RoutePath.distanceUnit.path) {
      screen = const DistanceUnitScreen();
      isSlideToTopAnim = true;
    } else if (routePath == RoutePath.paceUnit.path) {
      screen = const PaceUnitScreen();
      isSlideToTopAnim = true;
    }
    if (isSlideToTopAnim) {
      return PageRouteBuilder(
        pageBuilder: (_, anim1, anim2) => screen,
        transitionsBuilder: (context, anim1, anim2, child) => SlideToTopAnim(
          animation: anim1,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 500),
      );
    } else {
      return MaterialPageRoute(
        builder: (_) => screen,
        settings: settings,
      );
    }
  }
}
