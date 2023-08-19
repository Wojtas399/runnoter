import 'package:flutter/material.dart';

import '../../../dependency_injection.dart';
import '../../../domain/cubit/current_week_cubit.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/activity_item_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/shimmer_container.dart';
import '../../component/text/title_text_components.dart';
import '../../config/navigation/router.dart';
import '../../formatter/date_formatter.dart';
import '../../service/navigator_service.dart';
import 'current_week_add_activity_button.dart';

class CurrentWeekDayItem extends StatelessWidget {
  final Day day;

  const CurrentWeekDayItem({
    super.key,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _Date(
                date: day.date,
                isToday: day.isToday,
              ),
              CurrentWeekAddActivityButton(date: day.date),
            ],
          ),
          const Gap8(),
          Column(
            children: [
              ...day.workouts.map(
                (workout) => ActivityItem(
                  activity: workout,
                  onPressed: () => _onWorkoutPressed(workout.id),
                ),
              ),
              ...day.races.map(
                (race) => ActivityItem(
                  activity: race,
                  onPressed: () => _onRacePressed(race.id),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _onWorkoutPressed(String workoutId) async {
    final String? loggedUserId = await getIt<AuthService>().loggedUserId$.first;
    navigateTo(WorkoutPreviewRoute(
      userId: loggedUserId,
      workoutId: workoutId,
    ));
  }

  void _onRacePressed(String raceId) {
    navigateTo(
      RacePreviewRoute(raceId: raceId),
    );
  }
}

class CurrentWeekDayItemShimmer extends StatelessWidget {
  const CurrentWeekDayItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerContainer(height: 24, width: 150),
          Gap8(),
          ShimmerContainer(height: 48, width: double.infinity),
        ],
      ),
    );
  }
}

class _Date extends StatelessWidget {
  final DateTime date;
  final bool isToday;

  const _Date({
    required this.date,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isToday
            ? Theme.of(context).colorScheme.primary
            : Colors.transparent,
        borderRadius: BorderRadius.circular(100),
      ),
      child: TitleMedium(
        date.toFullDate(context),
        color: isToday ? Theme.of(context).canvasColor : null,
      ),
    );
  }
}
