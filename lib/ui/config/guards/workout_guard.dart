import 'package:auto_route/auto_route.dart';

import '../../../data/model/workout.dart';
import '../../../data/repository/workout/workout_repository.dart';
import '../../../dependency_injection.dart';
import '../navigation/router.dart';

class WorkoutGuard extends AutoRouteGuard {
  final WorkoutRepository _workoutRepository;

  WorkoutGuard() : _workoutRepository = getIt<WorkoutRepository>();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final Parameters pathParams = resolver.route.pathParams;
    final String userId = pathParams.get('userId');
    final String workoutId = pathParams.get('workoutId');
    final Stream<Workout?> workout$ = _workoutRepository.getWorkoutById(
      userId: userId,
      workoutId: workoutId,
    );
    await for (final workout in workout$) {
      if (workout != null) {
        resolver.next(true);
        return;
      } else {
        final PageRouteInfo redirectPage = switch (router.topRoute.name) {
          CalendarRoute.name => const CalendarRoute(),
          ClientCalendarRoute.name => ClientRoute(clientId: userId),
          _ => const HomeBaseRoute(),
        } as PageRouteInfo;
        resolver.redirect(redirectPage);
        return;
      }
    }
  }
}
