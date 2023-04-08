import 'package:flutter/material.dart';

import '../current_week_cubit.dart';

class DayItem extends StatelessWidget {
  final Day day;

  const DayItem({
    super.key,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        day.date.toString(),
      ),
    );
  }
}
