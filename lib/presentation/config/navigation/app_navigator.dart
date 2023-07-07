import 'package:flutter/material.dart';

import '../../screen/screens.dart';
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
    } else if (routePath == RoutePath.workoutPreview.path) {
      screen = WorkoutPreviewScreen(
        workoutId: settings.arguments as String,
      );
    } else if (routePath == RoutePath.workoutCreator.path) {
      screen = WorkoutCreatorScreen(
        arguments: settings.arguments as WorkoutCreatorArguments,
      );
    } else if (routePath == RoutePath.runStatusCreator.path) {
      screen = RunStatusCreatorScreen(
        arguments: settings.arguments as RunStatusCreatorArguments,
      );
    } else if (routePath == RoutePath.dayPreview.path) {
      screen = DayPreviewScreen(
        date: settings.arguments as DateTime,
      );
    } else if (routePath == RoutePath.healthMeasurementCreator.path) {
      screen = HealthMeasurementCreatorScreen(
        date: settings.arguments as DateTime?,
      );
    } else if (routePath == RoutePath.healthMeasurements.path) {
      screen = const HealthMeasurementsScreen();
    } else if (routePath == RoutePath.bloodTestCreator.path) {
      screen = BloodTestCreatorScreen(
        bloodTestId: settings.arguments as String?,
      );
    } else if (routePath == RoutePath.bloodTestPreview.path) {
      screen = BloodTestPreviewScreen(
        bloodTestId: settings.arguments as String,
      );
    } else if (routePath == RoutePath.raceCreator.path) {
      screen = RaceCreatorScreen(
        arguments: settings.arguments as RaceCreatorArguments?,
      );
    } else if (routePath == RoutePath.racePreview.path) {
      screen = RacePreviewScreen(
        raceId: settings.arguments as String,
      );
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
