import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/mileage/mileage_cubit.dart';
import '../../../domain/repository/workout_repository.dart';
import 'mileage_content.dart';

@RoutePage()
class MileageScreen extends StatelessWidget {
  const MileageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CubitProvider(
      child: MileageContent(),
    );
  }
}

class _CubitProvider extends StatelessWidget {
  final Widget child;

  const _CubitProvider({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MileageCubit(
        workoutRepository: context.read<WorkoutRepository>(),
      )..initialize(),
      child: child,
    );
  }
}
