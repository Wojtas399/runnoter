import 'package:firebase/firebase.dart';
import 'package:firebase/service/firebase_blood_test_parameter_service.dart';
import 'package:firebase/service/firebase_workout_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../common/date_service.dart';
import '../../data/repository_impl/blood_test_parameter_repository_impl.dart';
import '../../data/repository_impl/health_measurement_repository_impl.dart';
import '../../data/repository_impl/user_repository_impl.dart';
import '../../data/repository_impl/workout_repository_impl.dart';
import '../../domain/repository/blood_test_parameter_repository.dart';
import '../../domain/repository/health_measurement_repository.dart';
import '../../domain/repository/user_repository.dart';
import '../../domain/repository/workout_repository.dart';

class RepositoriesProvider extends StatelessWidget {
  final Widget child;

  const RepositoriesProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        Provider<UserRepository>(
          create: (_) => UserRepositoryImpl(
            firebaseUserService: FirebaseUserService(),
            firebaseAppearanceSettingsService:
                FirebaseAppearanceSettingsService(),
            firebaseWorkoutSettingsService: FirebaseWorkoutSettingsService(),
          ),
        ),
        Provider<WorkoutRepository>(
          create: (_) => WorkoutRepositoryImpl(
            firebaseWorkoutService: FirebaseWorkoutService(),
            dateService: DateService(),
          ),
        ),
        Provider<HealthMeasurementRepository>(
          create: (_) => HealthMeasurementRepositoryImpl(
            dateService: DateService(),
            firebaseHealthMeasurementService:
                FirebaseHealthMeasurementService(),
          ),
        ),
        Provider<BloodTestParameterRepository>(
          create: (_) => BloodTestParameterRepositoryImpl(
            firebaseBloodTestParameterService:
                FirebaseBloodTestParameterService(),
          ),
        )
      ],
      child: child,
    );
  }
}
