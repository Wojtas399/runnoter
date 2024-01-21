import 'package:auto_route/auto_route.dart';

import '../../../data/model/race.dart';
import '../../../data/repository/race/race_repository.dart';
import '../../../dependency_injection.dart';
import '../navigation/router.dart';

class RaceGuard extends AutoRouteGuard {
  final RaceRepository _raceRepository;

  RaceGuard() : _raceRepository = getIt<RaceRepository>();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final Parameters pathParams = resolver.route.pathParams;
    final String userId = pathParams.get('userId');
    final String raceId = pathParams.get('raceId');
    final Stream<Race?> race$ = _raceRepository.getRaceById(
      raceId: raceId,
      userId: userId,
    );
    await for (final race in race$) {
      if (race != null) {
        resolver.next(true);
        return;
      } else {
        final PageRouteInfo redirectPage = switch (router.topRoute.name) {
          CalendarRoute.name => const CalendarRoute(),
          RacesRoute.name => const RacesRoute(),
          ClientCalendarRoute.name => ClientRoute(clientId: userId),
          ClientRacesRoute.name => ClientRoute(clientId: userId),
          _ => const HomeBaseRoute(),
        };
        resolver.redirect(redirectPage);
        return;
      }
    }
  }
}
