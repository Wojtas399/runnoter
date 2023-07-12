import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';

import '../config/navigation/router.dart';
import 'dialog_service.dart';

void navigateTo(PageRouteInfo route) {
  hideSnackbar();
  GetIt.I.get<AppRouter>().push(route);
}

void navigateAndRemoveUntil(PageRouteInfo route) {
  hideSnackbar();
  GetIt.I.get<AppRouter>().navigate(route);
}

void navigateBack<T>({
  T? result,
}) {
  hideSnackbar();
  GetIt.I.get<AppRouter>().pop(result);
}

void navigateBackToRoute() {
  hideSnackbar();
  GetIt.I.get<AppRouter>().popUntilRoot();
}
