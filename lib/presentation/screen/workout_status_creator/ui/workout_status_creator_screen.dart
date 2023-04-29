import 'package:flutter/material.dart';

class WorkoutStatusCreatorScreen extends StatelessWidget {
  final String workoutId;

  const WorkoutStatusCreatorScreen({
    super.key,
    required this.workoutId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout status creator'),
      ),
    );
  }
}
