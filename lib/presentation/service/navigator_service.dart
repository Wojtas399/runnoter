import 'package:flutter/cupertino.dart';

import '../config/navigation/routes.dart';

void navigateTo({
  required BuildContext context,
  required Routes route,
}) {
  Navigator.of(context).pushNamed(route.path);
}

void navigateAndRemoveUntil({
  required BuildContext context,
  required Routes route,
}) {
  Navigator.of(context).pushNamedAndRemoveUntil(
    route.path,
    ModalRoute.withName(route.path),
  );
}

void navigateBack({
  required BuildContext context,
}) {
  Navigator.of(context).pop();
}
