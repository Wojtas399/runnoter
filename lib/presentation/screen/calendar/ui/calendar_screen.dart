import 'package:flutter/material.dart';

import '../../../component/calendar/calendar_component.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Calendar(
          initialDate: DateTime.now(),
          markedDates: const [],
        ),
      ),
    );
  }
}
