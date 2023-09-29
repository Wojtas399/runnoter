sealed class DayPreviewDialogAction {
  const DayPreviewDialogAction();
}

class DayPreviewDialogActionAddWorkout extends DayPreviewDialogAction {
  final DateTime date;

  const DayPreviewDialogActionAddWorkout({
    required this.date,
  });
}

class DayPreviewDialogActionAddRace extends DayPreviewDialogAction {
  final DateTime date;

  const DayPreviewDialogActionAddRace({
    required this.date,
  });
}

class DayPreviewDialogActionShowWorkout extends DayPreviewDialogAction {
  final String workoutId;

  const DayPreviewDialogActionShowWorkout({
    required this.workoutId,
  });
}

class DayPreviewDialogActionShowRace extends DayPreviewDialogAction {
  final String raceId;

  const DayPreviewDialogActionShowRace({
    required this.raceId,
  });
}
