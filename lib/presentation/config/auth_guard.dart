import 'package:auto_route/auto_route.dart';

import '../../dependency_injection.dart';
import '../../domain/service/auth_service.dart';
import 'navigation/router.dart';

class AuthGuard extends AutoRouteGuard {
  final AuthService _authService;

  AuthGuard() : _authService = getIt<AuthService>();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final String? loggedUser = await _authService.loggedUserId$.first;
    if (loggedUser != null) {
      resolver.next(true);
    } else {
      resolver.redirect(const SignInRoute());
    }
  }
}
