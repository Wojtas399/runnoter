import 'package:firebase/firebase.dart';
import 'package:firebase/service/firebase_race_service.dart';
import 'package:firebase/service/firebase_workout_service.dart';
import 'package:get_it/get_it.dart';

import 'common/date_service.dart';
import 'data/repository_impl/blood_test_repository_impl.dart';
import 'data/repository_impl/health_measurement_repository_impl.dart';
import 'data/repository_impl/race_repository_impl.dart';
import 'data/repository_impl/user_repository_impl.dart';
import 'data/repository_impl/workout_repository_impl.dart';
import 'data/service_impl/auth_service_impl.dart';
import 'domain/repository/blood_test_repository.dart';
import 'domain/repository/health_measurement_repository.dart';
import 'domain/repository/race_repository.dart';
import 'domain/repository/user_repository.dart';
import 'domain/repository/workout_repository.dart';
import 'domain/service/auth_service.dart';
import 'domain/use_case/get_logged_user_gender_use_case.dart';
import 'presentation/config/body_sizes.dart';
import 'presentation/config/navigation/router.dart';
import 'presentation/config/screen_sizes.dart';

final getIt = GetIt.I;

void setUpGetIt() {
  getIt.registerLazySingleton(() => AppRouter());
  getIt.registerLazySingleton(() => ScreenSizes());
  getIt.registerLazySingleton(() => BodySizes());
  getIt.registerFactory(() => DateService());
  getIt.registerLazySingleton<AuthService>(
    () => AuthServiceImpl(
      firebaseAuthService: FirebaseAuthService(),
    ),
  );
  _registerRepositories();
  _registerUseCases();
}

void resetGetItRepositories() {
  getIt.resetLazySingleton<UserRepository>();
  getIt.resetLazySingleton<WorkoutRepository>();
  getIt.resetLazySingleton<HealthMeasurementRepository>();
  getIt.resetLazySingleton<BloodTestRepository>();
  getIt.resetLazySingleton<RaceRepository>();
}

void _registerRepositories() {
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      firebaseUserService: FirebaseUserService(),
      firebaseAppearanceSettingsService: FirebaseAppearanceSettingsService(),
      firebaseWorkoutSettingsService: FirebaseWorkoutSettingsService(),
    ),
  );
  getIt.registerLazySingleton<WorkoutRepository>(
    () => WorkoutRepositoryImpl(
      firebaseWorkoutService: FirebaseWorkoutService(),
    ),
  );
  getIt.registerLazySingleton<HealthMeasurementRepository>(
    () => HealthMeasurementRepositoryImpl(
      firebaseHealthMeasurementService: FirebaseHealthMeasurementService(),
    ),
  );
  getIt.registerLazySingleton<BloodTestRepository>(
    () => BloodTestRepositoryImpl(
      firebaseBloodTestService: FirebaseBloodTestService(),
    ),
  );
  getIt.registerLazySingleton<RaceRepository>(
    () => RaceRepositoryImpl(
      firebaseRaceService: FirebaseRaceService(),
    ),
  );
}

void _registerUseCases() {
  getIt.registerFactory(() => GetLoggedUserGenderUseCase());
}
