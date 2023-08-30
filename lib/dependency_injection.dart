import 'package:firebase/firebase.dart';
import 'package:get_it/get_it.dart';

import 'common/date_service.dart';
import 'data/repository_impl/blood_test_repository_impl.dart';
import 'data/repository_impl/chat_repository_impl.dart';
import 'data/repository_impl/health_measurement_repository_impl.dart';
import 'data/repository_impl/message_repository_impl.dart';
import 'data/repository_impl/person_repository_impl.dart';
import 'data/repository_impl/race_repository_impl.dart';
import 'data/repository_impl/user_repository_impl.dart';
import 'data/repository_impl/workout_repository_impl.dart';
import 'data/service_impl/auth_service_impl.dart';
import 'data/service_impl/coaching_request_service_impl.dart';
import 'domain/cubit/date_range_manager_cubit.dart';
import 'domain/repository/blood_test_repository.dart';
import 'domain/repository/chat_repository.dart';
import 'domain/repository/health_measurement_repository.dart';
import 'domain/repository/message_repository.dart';
import 'domain/repository/person_repository.dart';
import 'domain/repository/race_repository.dart';
import 'domain/repository/user_repository.dart';
import 'domain/repository/workout_repository.dart';
import 'domain/service/auth_service.dart';
import 'domain/service/coaching_request_service.dart';
import 'domain/use_case/add_user_data_use_case.dart';
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
  _registerFirebaseServices();
  _registerServices();
  _registerRepositories();
  _registerUseCases();
}

void resetGetItRepositories() {
  getIt.resetLazySingleton<UserRepository>();
  getIt.resetLazySingleton<PersonRepository>();
  getIt.resetLazySingleton<WorkoutRepository>();
  getIt.resetLazySingleton<HealthMeasurementRepository>();
  getIt.resetLazySingleton<BloodTestRepository>();
  getIt.resetLazySingleton<RaceRepository>();
  getIt.resetLazySingleton<ChatRepository>();
  getIt.resetLazySingleton<MessageRepository>();
}

void _registerFirebaseServices() {
  getIt.registerFactory(() => FirebaseAuthService());
  getIt.registerFactory(() => FirebaseUserService());
  getIt.registerFactory(() => FirebaseAppearanceSettingsService());
  getIt.registerFactory(() => FirebaseActivitiesSettingsService());
  getIt.registerFactory(() => FirebaseWorkoutService());
  getIt.registerFactory(() => FirebaseHealthMeasurementService());
  getIt.registerFactory(() => FirebaseBloodTestService());
  getIt.registerFactory(() => FirebaseRaceService());
  getIt.registerFactory(() => FirebaseCoachingRequestService());
}

void _registerServices() {
  getIt.registerFactory<AuthService>(() => AuthServiceImpl());
  getIt.registerFactory<CoachingRequestService>(
    () => CoachingRequestServiceImpl(),
  );
  getIt.registerFactory(() => DateRangeManagerCubit());
}

void _registerRepositories() {
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());
  getIt.registerLazySingleton<PersonRepository>(() => PersonRepositoryImpl());
  getIt.registerLazySingleton<WorkoutRepository>(() => WorkoutRepositoryImpl());
  getIt.registerLazySingleton<HealthMeasurementRepository>(
    () => HealthMeasurementRepositoryImpl(),
  );
  getIt.registerLazySingleton<BloodTestRepository>(
    () => BloodTestRepositoryImpl(),
  );
  getIt.registerLazySingleton<RaceRepository>(() => RaceRepositoryImpl());
  getIt.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl());
  getIt.registerLazySingleton<MessageRepository>(() => MessageRepositoryImpl());
}

void _registerUseCases() {
  getIt.registerFactory(() => GetLoggedUserGenderUseCase());
  getIt.registerFactory(() => AddUserDataUseCase());
}
