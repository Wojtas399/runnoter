import 'package:flutter/material.dart';

import '../../../../domain/model/workout_stage.dart';
import '../../../formatter/workout_stage_formatter.dart';

class WorkoutCreatorWorkoutStageItem extends StatelessWidget {
  final WorkoutStage workoutStage;

  const WorkoutCreatorWorkoutStageItem({
    super.key,
    required this.workoutStage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    workoutStage.toUIFormat(context),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  _onMoreButtonPressed();
                },
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onMoreButtonPressed() {
    //TODO
  }
}
