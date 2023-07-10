import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';

import '../config/navigation/routes.dart';
import 'dialog_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void navigateTo({
  required CustomRoute route,
}) {
  hideSnackbar();
  Object? arguments;
  if (route is CustomRouteWithArguments) {
    arguments = route.arguments;
  }
  navigatorKey.currentState?.pushNamed(
    route.path.path,
    arguments: arguments,
  );
}

void navigateAndRemoveUntil({
  required CustomRoute route,
}) {
  navigatorKey.currentState?.pushNamedAndRemoveUntil(
    route.path.path,
    material.ModalRoute.withName(route.path.path),
  );
}

void navigateBack<T>({
  T? result,
}) {
  hideSnackbar();
  navigatorKey.currentState?.pop(result);
}
