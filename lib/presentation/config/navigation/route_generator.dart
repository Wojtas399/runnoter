import 'package:flutter/material.dart';

import '../../screen/screens.dart';
import 'routes.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  final String? routePath = settings.name;
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
  }
  return MaterialPageRoute(
    builder: (_) => screen,
    settings: settings,
  );
}
