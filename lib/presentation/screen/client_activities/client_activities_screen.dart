import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../component/calendar/calendar_component.dart';
import '../../config/navigation/router.dart';
import '../../dialog/day_preview/day_preview_dialog.dart';
import '../../dialog/day_preview/day_preview_dialog_actions.dart';
import '../../formatter/date_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';

@RoutePage()
class ClientActivitiesScreen extends StatelessWidget {
  const ClientActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Calendar(
        workouts: const [],
        races: const [],
        onWorkoutPressed: _navigateToWorkout,
        onRacePressed: _navigateToRace,
        onAddWorkout: _navigateToWorkoutCreator,
        onAddRace: _navigateToRaceCreator,
        onDayPressed: (DateTime date) => _onDayPressed(context, date),
      ),
    );
  }

  void _navigateToWorkout(String workoutId) {
    navigateTo(WorkoutPreviewRoute(workoutId: workoutId));
  }

  void _navigateToRace(String raceId) {
    navigateTo(RacePreviewRoute(raceId: raceId));
  }

  void _navigateToWorkoutCreator(DateTime date) {
    navigateTo(WorkoutCreatorRoute(date: date.toPathFormat()));
  }

  void _navigateToRaceCreator(DateTime date) {
    navigateTo(RaceCreatorRoute(dateStr: date.toPathFormat()));
  }

  Future<void> _onDayPressed(BuildContext context, DateTime date) async {
    final DayPreviewDialogAction? action =
        await showDialogDependingOnScreenSize(DayPreviewDialog(date: date));
    if (action == null) return;
    switch (action) {
      case DayPreviewDialogActionAddWorkout():
        _navigateToWorkoutCreator(action.date);
        break;
      case DayPreviewDialogActionAddRace():
        _navigateToRaceCreator(action.date);
        break;
      case DayPreviewDialogActionShowWorkout():
        _navigateToWorkout(action.workoutId);
        break;
      case DayPreviewDialogActionShowRace():
        _navigateToRace(action.raceId);
        break;
    }
  }
}
