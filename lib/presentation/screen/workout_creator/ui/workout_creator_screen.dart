import 'package:flutter/material.dart';

class WorkoutCreatorScreen extends StatelessWidget {
  final DateTime date;

  const WorkoutCreatorScreen({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout creator'),
      ),
    );
  }
}
