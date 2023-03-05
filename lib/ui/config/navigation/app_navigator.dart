import 'package:flutter/material.dart';
import 'package:runnoter/ui/config/navigation/routes.dart';
import 'package:runnoter/ui/screens/sign_in/ui/sign_in_screen.dart';

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
    }
    return MaterialPageRoute(
      builder: (_) => screen,
    );
  }
}
