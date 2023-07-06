part of 'home_screen.dart';

class _Destination {
  final IconData iconData;
  final IconData selectedIconData;
  final String label;

  const _Destination({
    required this.iconData,
    required this.selectedIconData,
    required this.label,
  });
}

class _DestinationHome extends _Destination {
  _DestinationHome({
    required BuildContext context,
  }) : super(
          iconData: Icons.home_outlined,
          selectedIconData: Icons.home,
          label: Str.of(context).homeTitle,
        );
}

class _DestinationCurrentWeek extends _Destination {
  _DestinationCurrentWeek({
    required BuildContext context,
  }) : super(
          iconData: Icons.date_range_outlined,
          selectedIconData: Icons.date_range,
          label: Str.of(context).homeCurrentWeekTitle,
        );
}

class _DestinationCalendar extends _Destination {
  _DestinationCalendar({
    required BuildContext context,
  }) : super(
          iconData: Icons.calendar_month_outlined,
          selectedIconData: Icons.calendar_month,
          label: Str.of(context).homeCalendarTitle,
        );
}

class _DestinationHealth extends _Destination {
  _DestinationHealth({
    required BuildContext context,
  }) : super(
          iconData: Icons.health_and_safety_outlined,
          selectedIconData: Icons.health_and_safety,
          label: Str.of(context).homeHealthTitle,
        );
}

class _DestinationProfile extends _Destination {
  _DestinationProfile({
    required BuildContext context,
  }) : super(
          iconData: Icons.account_circle_outlined,
          selectedIconData: Icons.account_circle,
          label: Str.of(context).homeProfileTitle,
        );
}

class _DestinationMileage extends _Destination {
  _DestinationMileage({
    required BuildContext context,
  }) : super(
          iconData: Icons.insert_chart_outlined,
          selectedIconData: Icons.insert_chart,
          label: Str.of(context).homeMileageTitle,
        );
}

class _DestinationBlood extends _Destination {
  _DestinationBlood({
    required BuildContext context,
  }) : super(
          iconData: Icons.water_drop_outlined,
          selectedIconData: Icons.water_drop,
          label: Str.of(context).homeBloodTestsTitle,
        );
}

class _DestinationRaces extends _Destination {
  _DestinationRaces({
    required BuildContext context,
  }) : super(
          iconData: Icons.emoji_events_outlined,
          selectedIconData: Icons.emoji_events,
          label: Str.of(context).homeRacesTitle,
        );
}

class _Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > maxMobileWidth) {
      return const _DesktopContent();
    }
    return const _MobileContent();
  }
}
