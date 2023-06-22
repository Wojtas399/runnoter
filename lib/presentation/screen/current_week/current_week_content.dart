part of 'current_week_screen.dart';

class CurrentWeekContent extends StatelessWidget {
  const CurrentWeekContent({
    super.key,
  });

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
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
      itemBuilder: (_, int itemIndex) => DayItem(
        day: days[itemIndex],
      ),
      separatorBuilder: (_, int itemIndex) => const Divider(),
    );
  }
}
