import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/cubit/workout_preview/workout_preview_cubit.dart';
import '../../component/page_not_found_component.dart';
import 'workout_preview_content.dart';

@RoutePage()
class WorkoutPreviewScreen extends StatelessWidget {
  final String? userId;
  final String? workoutId;

  const WorkoutPreviewScreen({
    super.key,
    @PathParam('userId') this.userId,
    @PathParam('workoutId') this.workoutId,
  });

  @override
  Widget build(BuildContext context) {
    return userId != null && workoutId != null
        ? BlocProvider(
            create: (_) => WorkoutPreviewCubit(
              userId: userId!,
              workoutId: workoutId!,
            )..initialize(),
            child: const WorkoutPreviewContent(),
          )
        : const PageNotFound();
  }
}
