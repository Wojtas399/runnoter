import 'package:firebase/firebase.dart';
import 'package:firebase/service/firebase_race_service.dart';
import 'package:firebase/service/firebase_workout_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/date_service.dart';
import '../../data/repository_impl/blood_test_repository_impl.dart';
import '../../data/repository_impl/health_measurement_repository_impl.dart';
import '../../data/repository_impl/race_repository_impl.dart';
import '../../data/repository_impl/user_repository_impl.dart';
import '../../data/repository_impl/workout_repository_impl.dart';
import '../../domain/repository/blood_test_repository.dart';
import '../../domain/repository/health_measurement_repository.dart';
import '../../domain/repository/race_repository.dart';
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
        RepositoryProvider<UserRepository>(
          create: (_) => UserRepositoryImpl(
            firebaseUserService: FirebaseUserService(),
            firebaseAppearanceSettingsService:
                FirebaseAppearanceSettingsService(),
            firebaseWorkoutSettingsService: FirebaseWorkoutSettingsService(),
          ),
        ),
        RepositoryProvider<WorkoutRepository>(
          create: (_) => WorkoutRepositoryImpl(
            firebaseWorkoutService: FirebaseWorkoutService(),
            dateService: DateService(),
          ),
        ),
        RepositoryProvider<HealthMeasurementRepository>(
          create: (_) => HealthMeasurementRepositoryImpl(
            dateService: DateService(),
            firebaseHealthMeasurementService:
                FirebaseHealthMeasurementService(),
          ),
        ),
        RepositoryProvider<BloodTestRepository>(
          create: (_) => BloodTestRepositoryImpl(
            firebaseBloodTestService: FirebaseBloodTestService(),
          ),
        ),
        RepositoryProvider<RaceRepository>(
          create: (_) => RaceRepositoryImpl(
            firebaseRaceService: FirebaseRaceService(),
            dateService: DateService(),
          ),
        ),
      ],
      child: child,
    );
  }
}
