import 'package:auto_route/auto_route.dart';

import '../../dependency_injection.dart';
import '../config/navigation/router.dart';
import 'dialog_service.dart';

void navigateTo(PageRouteInfo route) {
  hideSnackbar();
  getIt<AppRouter>().push(route);
}

void navigateAndRemoveUntil(PageRouteInfo route) {
  hideSnackbar();
  getIt<AppRouter>().replaceAll([route]);
}

void popRoute<T>({
  T? result,
}) {
  hideSnackbar();
  getIt<AppRouter>().pop(result);
}

void popUntilRoot() {
  hideSnackbar();
  getIt<AppRouter>().popUntilRoot();
}

void navigateBack() {
  hideSnackbar();
  getIt<AppRouter>().back();
}
