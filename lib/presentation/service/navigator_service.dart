import 'package:flutter/material.dart' as material;

import '../config/navigation/routes.dart';
import 'dialog_service.dart';

void navigateTo({
  required material.BuildContext context,
  required CustomRoute route,
}) {
  hideSnackbar(context: context);
  Object? arguments;
  if (route is CustomRouteWithArguments) {
    arguments = route.arguments;
  }
  material.Navigator.of(context).pushNamed(
    route.path.path,
    arguments: arguments,
  );
}

void navigateAndRemoveUntil({
  required material.BuildContext context,
  required CustomRoute route,
}) {
  material.Navigator.of(context).pushNamedAndRemoveUntil(
    route.path.path,
    material.ModalRoute.withName(route.path.path),
  );
}

void navigateBack<T>({
  required material.BuildContext context,
  T? result,
}) {
  hideSnackbar(context: context);
  material.Navigator.of(context).pop(result);
}
