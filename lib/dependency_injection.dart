import 'package:firebase/firebase.dart';
import 'package:firebase/service/firebase_workout_service.dart';
import 'package:get_it/get_it.dart';

import 'common/date_service.dart';
import 'data/repository_impl/user_repository_impl.dart';
import 'data/repository_impl/workout_repository_impl.dart';
import 'data/service_impl/auth_service_impl.dart';
import 'domain/repository/user_repository.dart';
import 'domain/repository/workout_repository.dart';
import 'domain/service/auth_service.dart';
import 'presentation/config/body_sizes.dart';
import 'presentation/config/navigation/router.dart';
import 'presentation/config/screen_sizes.dart';

final getIt = GetIt.I;

void setUpGetIt() {
  getIt.registerLazySingleton(() => AppRouter());
  getIt.registerLazySingleton(() => ScreenSizes());
  getIt.registerLazySingleton(() => BodySizes());
  getIt.registerLazySingleton<AuthService>(
    () => AuthServiceImpl(
      firebaseAuthService: FirebaseAuthService(),
    ),
  );
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
      dateService: DateService(),
    ),
  );
}

void resetGetItRepositories() {
  getIt.resetLazySingleton<UserRepository>();
  getIt.resetLazySingleton<WorkoutRepository>();
}
