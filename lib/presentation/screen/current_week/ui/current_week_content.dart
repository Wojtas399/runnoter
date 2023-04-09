import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../current_week_cubit.dart';
import 'day_item.dart';

class CurrentWeekContent extends StatelessWidget {
  const CurrentWeekContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: _Workouts(),
    );
  }
}

class _Workouts extends StatelessWidget {
  const _Workouts();

  @override
  Widget build(BuildContext context) {
    final List<Day>? days = context.select(
      (CurrentWeekCubit cubit) => cubit.state,
    );

    if (days == null) {
      return const CircularProgressIndicator();
    }

    return ListView.separated(
      itemCount: days.length,
      itemBuilder: (_, int itemIndex) => DayItem(
        day: days[itemIndex],
      ),
      separatorBuilder: (_, int itemIndex) => const Divider(),
    );
  }
}
