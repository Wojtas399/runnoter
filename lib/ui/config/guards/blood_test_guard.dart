import 'package:auto_route/auto_route.dart';

import '../../../data/model/blood_test.dart';
import '../../../data/repository/blood_test/blood_test_repository.dart';
import '../../../dependency_injection.dart';
import '../navigation/router.dart';

class BloodTestGuard extends AutoRouteGuard {
  final BloodTestRepository _bloodTestRepository;

  BloodTestGuard() : _bloodTestRepository = getIt<BloodTestRepository>();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final Parameters pathParams = resolver.route.pathParams;
    final String userId = pathParams.get('userId');
    final String bloodTestId = pathParams.get('bloodTestId');
    final Stream<BloodTest?> bloodTest$ = _bloodTestRepository.getTestById(
      bloodTestId: bloodTestId,
      userId: userId,
    );
    await for (final bloodTest in bloodTest$) {
      if (bloodTest != null) {
        resolver.next(true);
        return;
      } else {
        final PageRouteInfo redirectPage = switch (router.topRoute.name) {
          BloodTestsRoute.name => const BloodTestsRoute(),
          ClientBloodTestsRoute.name => ClientRoute(clientId: userId),
          _ => const HomeBaseRoute(),
        } as PageRouteInfo;
        resolver.redirect(redirectPage);
        return;
      }
    }
  }
}
