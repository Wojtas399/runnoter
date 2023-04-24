import 'package:flutter/material.dart' as material;

import '../config/navigation/routes.dart';

void navigateTo({
  required material.BuildContext context,
  required CustomRoute route,
}) {
  material.Navigator.of(context).pushNamed(
    route.path.path,
    arguments: route.arguments,
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
  material.Navigator.of(context).pop(result);
}
