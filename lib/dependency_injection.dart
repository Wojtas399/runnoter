import 'package:firebase/firebase.dart';
import 'package:get_it/get_it.dart';

import 'common/date_service.dart';
import 'data/repository/blood_test/blood_test_repository.dart';
import 'data/repository/blood_test/blood_test_repository_impl.dart';
import 'data/repository/chat/chat_repository.dart';
import 'data/repository/chat/chat_repository_impl.dart';
import 'data/repository/health_measurement/health_measurement_repository.dart';
import 'data/repository/health_measurement/health_measurement_repository_impl.dart';
import 'data/repository/message/message_repository.dart';
import 'data/repository/message/message_repository_impl.dart';
import 'data/repository/message_image/message_image_repository.dart';
import 'data/repository/message_image/message_image_repository_impl.dart';
import 'data/repository/person/person_repository.dart';
import 'data/repository/person/person_repository_impl.dart';
import 'data/repository/race/race_repository.dart';
import 'data/repository/race/race_repository_impl.dart';
import 'data/repository/user/user_repository.dart';
import 'data/repository/user/user_repository_impl.dart';
import 'data/repository/workout/workout_repository.dart';
import 'data/repository/workout/workout_repository_impl.dart';
import 'data/service/auth/auth_service.dart';
import 'data/service/auth/auth_service_impl.dart';
import 'data/service/coaching_request/coaching_request_service.dart';
import 'data/service/coaching_request/coaching_request_service_impl.dart';
import 'domain/use_case/add_user_data_use_case.dart';
import 'domain/use_case/delete_chat_use_case.dart';
import 'domain/use_case/get_received_coaching_requests_with_sender_info_use_case.dart';
import 'domain/use_case/get_sent_coaching_requests_with_receiver_info_use_case.dart';
import 'domain/use_case/load_chat_id_use_case.dart';
import 'ui/config/navigation/router.dart';
import 'ui/cubit/date_range_manager_cubit.dart';

final getIt = GetIt.I;

void setUpGetIt() {
  getIt.registerLazySingleton(() => AppRouter());
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
  getIt.resetLazySingleton<MessageImageRepository>();
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
  getIt.registerFactory(() => FirebaseChatService());
  getIt.registerFactory(() => FirebaseMessageService());
  getIt.registerFactory(() => FirebaseMessageImageService());
  getIt.registerFactory(() => FirebaseStorageService());
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
  getIt.registerLazySingleton<MessageImageRepository>(
    () => MessageImageRepositoryImpl(),
  );
}

void _registerUseCases() {
  getIt.registerFactory(() => AddUserDataUseCase());
  getIt.registerFactory(() => LoadChatIdUseCase());
  getIt.registerFactory(() => GetSentCoachingRequestsWithReceiverInfoUseCase());
  getIt.registerFactory(
    () => GetReceivedCoachingRequestsWithSenderInfoUseCase(),
  );
  getIt.registerFactory(() => DeleteChatUseCase());
}
