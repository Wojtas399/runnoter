import 'package:flutter/material.dart';

import '../../screen/forgot_password/ui/forgot_password_screen.dart';
import '../../screen/home/home_screen.dart';
import '../../screen/sign_in/ui/sign_in_screen.dart';
import '../../screen/sign_up/ui/sign_up_screen.dart';
import 'routes.dart';

class AppNavigator extends StatelessWidget {
  const AppNavigator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: Routes.signIn.path,
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    final String? routePath = settings.name;
    Widget screen = const SignInScreen();
    if (routePath == Routes.signIn.path) {
      screen = const SignInScreen();
    } else if (routePath == Routes.signUp.path) {
      screen = const SignUpScreen();
    } else if (routePath == Routes.forgotPassword.path) {
      screen = const ForgotPasswordScreen();
    } else if (routePath == Routes.home.path) {
      screen = const HomeScreen();
    }
    return MaterialPageRoute(
      builder: (_) => screen,
    );
  }
}
