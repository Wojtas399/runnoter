import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../component/calendar/calendar_component.dart';

@RoutePage()
class ClientActivitiesScreen extends StatelessWidget {
  const ClientActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Calendar(workouts: [], races: []),
    );
  }
}
