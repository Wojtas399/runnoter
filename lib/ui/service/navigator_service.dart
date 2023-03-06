import 'package:flutter/cupertino.dart';
import 'package:runnoter/ui/config/navigation/routes.dart';

void navigateTo({
  required BuildContext context,
  required Routes route,
}) {
  Navigator.of(context).pushNamed(route.path);
}
