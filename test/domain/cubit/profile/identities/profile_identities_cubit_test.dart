import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/entity/user.dart';
import 'package:runnoter/data/interface/repository/blood_test_repository.dart';
import 'package:runnoter/data/interface/repository/health_measurement_repository.dart';
import 'package:runnoter/data/interface/repository/person_repository.dart';
import 'package:runnoter/data/interface/repository/race_repository.dart';
import 'package:runnoter/data/interface/repository/user_repository.dart';
import 'package:runnoter/data/interface/repository/workout_repository.dart';
import 'package:runnoter/data/interface/service/auth_service.dart';
import 'package:runnoter/data/interface/service/coaching_request_service.dart';
import 'package:runnoter/domain/additional_model/cubit_status.dart';
import 'package:runnoter/domain/additional_model/custom_exception.dart';
import 'package:runnoter/domain/cubit/profile/identities/profile_identities_cubit.dart';

import '../../../../creators/user_creator.dart';
import '../../../../mock/domain/repository/mock_blood_test_repository.dart';
import '../../../../mock/domain/repository/mock_health_measurement_repository.dart';
import '../../../../mock/domain/repository/mock_person_repository.dart';
import '../../../../mock/domain/repository/mock_race_repository.dart';
import '../../../../mock/domain/repository/mock_user_repository.dart';
import '../../../../mock/domain/repository/mock_workout_repository.dart';
import '../../../../mock/domain/service/mock_auth_service.dart';
import '../../../../mock/domain/service/mock_coaching_request_service.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();
  final workoutRepository = MockWorkoutRepository();
  final healthMeasurementRepository = MockHealthMeasurementRepository();
  final bloodTestRepository = MockBloodTestRepository();
  final raceRepository = MockRaceRepository();
  final coachingRequestService = MockCoachingRequestService();
  final personRepository = MockPersonRepository();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerSingleton<UserRepository>(userRepository);
    GetIt.I.registerSingleton<WorkoutRepository>(workoutRepository);
    GetIt.I.registerSingleton<HealthMeasurementRepository>(
      healthMeasurementRepository,
    );
    GetIt.I.registerSingleton<BloodTestRepository>(bloodTestRepository);
    GetIt.I.registerSingleton<RaceRepository>(raceRepository);
    GetIt.I.registerFactory<CoachingRequestService>(
      () => coachingRequestService,
    );
    GetIt.I.registerSingleton<PersonRepository>(personRepository);
  });

  tearDown(() {
    reset(authService);
    reset(userRepository);
    reset(workoutRepository);
    reset(healthMeasurementRepository);
    reset(bloodTestRepository);
    reset(raceRepository);
  });

  blocTest(
    'initialize, '
    'should set listener of logged user email, email verification status and data',
    build: () => ProfileIdentitiesCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      authService.mockHasLoggedUserVerifiedEmail(expected: true);
      authService.mockGetLoggedUserEmail(userEmail: 'email@example.com');
      userRepository.mockGetUserById(
        user: createUser(
          id: loggedUserId,
          accountType: AccountType.coach,
          gender: Gender.female,
          name: 'name',
          surname: 'surname',
          dateOfBirth: DateTime(2023, 1, 11),
        ),
      );
    },
    act: (cubit) => cubit.initialize(),
    expect: () => [
      ProfileIdentitiesState(
        status: const CubitStatusComplete(),
        accountType: AccountType.coach,
        gender: Gender.female,
        name: 'name',
        surname: 'surname',
        email: 'email@example.com',
        dateOfBirth: DateTime(2023, 1, 11),
        isEmailVerified: true,
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(() => authService.loggedUserEmail$).called(1);
      verify(() => authService.hasLoggedUserVerifiedEmail$).called(1);
      verify(() => userRepository.getUserById(userId: loggedUserId)).called(1);
    },
  );

  blocTest(
    'update gender, '
    "should update gender in state and should call method from user repository to update user's data with new gender",
    build: () => ProfileIdentitiesCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUser();
    },
    act: (cubit) => cubit.updateGender(Gender.female),
    expect: () => [
      const ProfileIdentitiesState(
        status: CubitStatusComplete(),
        gender: Gender.female,
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => userRepository.updateUser(
          userId: loggedUserId,
          gender: Gender.female,
        ),
      ).called(1);
    },
  );

  blocTest(
    'update gender, '
    'method from user repository to update user throws exception, '
    'should set previous gender',
    build: () => ProfileIdentitiesCubit(
      state: const ProfileIdentitiesState(
        status: CubitStatusInitial(),
        gender: Gender.male,
      ),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUser(throwable: 'Exception...');
    },
    act: (cubit) => cubit.updateGender(Gender.female),
    expect: () => [
      const ProfileIdentitiesState(
        status: CubitStatusComplete(),
        gender: Gender.female,
      ),
      const ProfileIdentitiesState(
        status: CubitStatusComplete(),
        gender: Gender.male,
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => userRepository.updateUser(
          userId: loggedUserId,
          gender: Gender.female,
        ),
      ).called(1);
    },
  );

  blocTest(
    'update gender, '
    'logged user does not exist, '
    'should emit no logged user info',
    build: () => ProfileIdentitiesCubit(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (cubit) => cubit.updateGender(Gender.female),
    expect: () => [
      const ProfileIdentitiesState(status: CubitStatusNoLoggedUser()),
    ],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'update gender, '
    'new gender is the same as current gender, '
    'should do nothing',
    build: () => ProfileIdentitiesCubit(
      state: const ProfileIdentitiesState(
        status: CubitStatusInitial(),
        gender: Gender.male,
      ),
    ),
    act: (cubit) => cubit.updateGender(Gender.male),
    expect: () => [],
  );

  blocTest(
    'update name, '
    'should call method from user repository to update user and should emit info that data have been saved',
    build: () => ProfileIdentitiesCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUser();
    },
    act: (cubit) => cubit.updateName('new name'),
    expect: () => [
      const ProfileIdentitiesState(status: CubitStatusLoading()),
      const ProfileIdentitiesState(
        status: CubitStatusComplete<ProfileIdentitiesCubitInfo>(
          info: ProfileIdentitiesCubitInfo.dataSaved,
        ),
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => userRepository.updateUser(
          userId: loggedUserId,
          name: 'new name',
        ),
      ).called(1);
    },
  );

  blocTest(
    'update name, '
    'logged user does not exist, '
    'should emit no logged user status',
    build: () => ProfileIdentitiesCubit(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (cubit) => cubit.updateName('new name'),
    expect: () => [
      const ProfileIdentitiesState(status: CubitStatusNoLoggedUser()),
    ],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'update surname, '
    'should call method from user repository to update user and should emit info that data have been saved',
    build: () => ProfileIdentitiesCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUser();
    },
    act: (cubit) => cubit.updateSurname('new surname'),
    expect: () => [
      const ProfileIdentitiesState(status: CubitStatusLoading()),
      const ProfileIdentitiesState(
        status: CubitStatusComplete<ProfileIdentitiesCubitInfo>(
          info: ProfileIdentitiesCubitInfo.dataSaved,
        ),
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => userRepository.updateUser(
          userId: loggedUserId,
          surname: 'new surname',
        ),
      ).called(1);
    },
  );

  blocTest(
    'update surname, '
    'logged user does not exist, '
    'should emit no logged user status',
    build: () => ProfileIdentitiesCubit(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (cubit) => cubit.updateSurname('new surname'),
    expect: () => [
      const ProfileIdentitiesState(status: CubitStatusNoLoggedUser()),
    ],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'update date of birth, '
    'should call method from user repository to update user and '
    'should emit info that data have been saved',
    build: () => ProfileIdentitiesCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUser();
    },
    act: (cubit) => cubit.updateDateOfBirth(DateTime(2023, 1, 11)),
    expect: () => [
      const ProfileIdentitiesState(status: CubitStatusLoading()),
      const ProfileIdentitiesState(
        status: CubitStatusComplete<ProfileIdentitiesCubitInfo>(
          info: ProfileIdentitiesCubitInfo.dataSaved,
        ),
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => userRepository.updateUser(
          userId: loggedUserId,
          dateOfBirth: DateTime(2023, 1, 11),
        ),
      ).called(1);
    },
  );

  blocTest(
    'update date of birth, '
    'logged user does not exist, '
    'should emit no logged user status',
    build: () => ProfileIdentitiesCubit(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (cubit) => cubit.updateDateOfBirth(DateTime(2023, 1, 11)),
    expect: () => [
      const ProfileIdentitiesState(status: CubitStatusNoLoggedUser()),
    ],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'update email, '
    'logged user id is null, '
    'should emit no logged user status',
    build: () => ProfileIdentitiesCubit(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (cubit) => cubit.updateEmail('email@example.com'),
    expect: () => [
      const ProfileIdentitiesState(status: CubitStatusNoLoggedUser()),
    ],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'update email, '
    'should call methods from auth service to update email and to send email verification and method from user repository to update user data with new email',
    build: () => ProfileIdentitiesCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      authService.mockUpdateEmail();
      authService.mockSendEmailVerification();
      userRepository.mockUpdateUser();
    },
    act: (cubit) => cubit.updateEmail('email@example.com'),
    expect: () => [
      const ProfileIdentitiesState(status: CubitStatusLoading()),
      const ProfileIdentitiesState(
        status: CubitStatusComplete<ProfileIdentitiesCubitInfo>(
          info: ProfileIdentitiesCubitInfo.emailChanged,
        ),
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => authService.updateEmail(newEmail: 'email@example.com'),
      ).called(1);
      verify(authService.sendEmailVerification).called(1);
      verify(
        () => userRepository.updateUser(
          userId: loggedUserId,
          email: 'email@example.com',
        ),
      ).called(1);
    },
  );

  blocTest(
    'update email, '
    'auth exception with email already in use code, '
    'should emit error status with email already in use error',
    build: () => ProfileIdentitiesCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      authService.mockUpdateEmail(
        throwable: const AuthException(
          code: AuthExceptionCode.emailAlreadyInUse,
        ),
      );
    },
    act: (cubit) => cubit.updateEmail('email@example.com'),
    expect: () => [
      const ProfileIdentitiesState(status: CubitStatusLoading()),
      const ProfileIdentitiesState(
        status: CubitStatusError<ProfileIdentitiesCubitError>(
          error: ProfileIdentitiesCubitError.emailAlreadyInUse,
        ),
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => authService.updateEmail(newEmail: 'email@example.com'),
      ).called(1);
    },
  );

  blocTest(
    'update email, '
    'network exception with request failed code, '
    'should emit network request failed status',
    build: () => ProfileIdentitiesCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      authService.mockUpdateEmail(
        throwable: const NetworkException(
          code: NetworkExceptionCode.requestFailed,
        ),
      );
    },
    act: (cubit) => cubit.updateEmail('email@example.com'),
    expect: () => [
      const ProfileIdentitiesState(status: CubitStatusLoading()),
      const ProfileIdentitiesState(status: CubitStatusNoInternetConnection()),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => authService.updateEmail(newEmail: 'email@example.com'),
      ).called(1);
    },
  );

  blocTest(
    'update email, '
    'unknown exception, '
    'should emit unknown error status and should rethrow exception',
    build: () => ProfileIdentitiesCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      authService.mockUpdateEmail(
        throwable: const UnknownException(message: 'unknown exception message'),
      );
    },
    act: (cubit) => cubit.updateEmail('email@example.com'),
    expect: () => [
      const ProfileIdentitiesState(status: CubitStatusLoading()),
      const ProfileIdentitiesState(status: CubitStatusUnknownError()),
    ],
    errors: () => [
      const UnknownException(message: 'unknown exception message'),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => authService.updateEmail(newEmail: 'email@example.com'),
      ).called(1);
    },
  );

  blocTest(
    'send email verification, '
    "should call auth service's method to send email verification and should emit emailVerificationSent info",
    build: () => ProfileIdentitiesCubit(),
    setUp: () => authService.mockSendEmailVerification(),
    act: (cubit) => cubit.sendEmailVerification(),
    expect: () => [
      const ProfileIdentitiesState(status: CubitStatusLoading()),
      const ProfileIdentitiesState(
        status: CubitStatusComplete<ProfileIdentitiesCubitInfo>(
          info: ProfileIdentitiesCubitInfo.emailVerificationSent,
        ),
      ),
    ],
    verify: (_) => verify(authService.sendEmailVerification).called(1),
  );

  blocTest(
    'update password, '
    'should call method from auth service to update password and should emit info that data have been saved',
    build: () => ProfileIdentitiesCubit(),
    setUp: () => authService.mockUpdatePassword(),
    act: (cubit) => cubit.updatePassword('newPassword'),
    expect: () => [
      const ProfileIdentitiesState(status: CubitStatusLoading()),
      const ProfileIdentitiesState(
        status: CubitStatusComplete<ProfileIdentitiesCubitInfo>(
            info: ProfileIdentitiesCubitInfo.dataSaved),
      ),
    ],
    verify: (_) => verify(
      () => authService.updatePassword(newPassword: 'newPassword'),
    ).called(1),
  );

  blocTest(
    'update password, '
    'network exception with request failed code, '
    'should emit network request failed status',
    build: () => ProfileIdentitiesCubit(),
    setUp: () => authService.mockUpdatePassword(
      throwable: const NetworkException(
        code: NetworkExceptionCode.requestFailed,
      ),
    ),
    act: (cubit) => cubit.updatePassword('newPassword'),
    expect: () => [
      const ProfileIdentitiesState(status: CubitStatusLoading()),
      const ProfileIdentitiesState(status: CubitStatusNoInternetConnection()),
    ],
    verify: (_) => verify(
      () => authService.updatePassword(newPassword: 'newPassword'),
    ).called(1),
  );

  blocTest(
    'update password, '
    'unknown exception, '
    'should emit unknown error status',
    build: () => ProfileIdentitiesCubit(),
    setUp: () => authService.mockUpdatePassword(
      throwable: const UnknownException(message: 'unknown exception message'),
    ),
    act: (cubit) => cubit.updatePassword('newPassword'),
    expect: () => [
      const ProfileIdentitiesState(status: CubitStatusLoading()),
      const ProfileIdentitiesState(status: CubitStatusUnknownError()),
    ],
    errors: () => [
      const UnknownException(message: 'unknown exception message'),
    ],
    verify: (_) => verify(
      () => authService.updatePassword(newPassword: 'newPassword'),
    ).called(1),
  );

  blocTest(
    'delete account, '
    'logged user does not exist, '
    'should emit no logged user status',
    build: () => ProfileIdentitiesCubit(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (cubit) => cubit.deleteAccount(),
    expect: () => [
      const ProfileIdentitiesState(status: CubitStatusNoLoggedUser()),
    ],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'delete account, '
    'should call methods to delete user data and account and should emit info that account has been deleted',
    build: () => ProfileIdentitiesCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      authService.mockDeleteAccount();
      userRepository.mockDeleteUser();
      workoutRepository.mockDeleteAllUserWorkouts();
      healthMeasurementRepository.mockDeleteAllUserMeasurements();
      bloodTestRepository.mockDeleteAllUserTests();
      raceRepository.mockDeleteAllUserRaces();
      coachingRequestService.mockDeleteCoachingRequestsByUserId();
      personRepository.mockRemoveCoachIdInAllMatchingPersons();
    },
    act: (cubit) => cubit.deleteAccount(),
    expect: () => [
      const ProfileIdentitiesState(status: CubitStatusLoading()),
      const ProfileIdentitiesState(
        status: CubitStatusComplete<ProfileIdentitiesCubitInfo>(
          info: ProfileIdentitiesCubitInfo.accountDeleted,
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => workoutRepository.deleteAllUserWorkouts(userId: loggedUserId),
      ).called(1);
      verify(
        () => healthMeasurementRepository.deleteAllUserMeasurements(
          userId: loggedUserId,
        ),
      ).called(1);
      verify(
        () => bloodTestRepository.deleteAllUserTests(userId: loggedUserId),
      ).called(1);
      verify(
        () => raceRepository.deleteAllUserRaces(userId: loggedUserId),
      ).called(1);
      verify(() => userRepository.deleteUser(userId: loggedUserId)).called(1);
      verify(
        () => coachingRequestService.deleteCoachingRequestsByUserId(
          userId: loggedUserId,
        ),
      ).called(1);
      verify(
        () => personRepository.removeCoachIdInAllMatchingPersons(
          coachId: loggedUserId,
        ),
      ).called(1);
      verify(() => authService.deleteAccount()).called(1);
    },
  );

  blocTest(
    'delete account, '
    'network exception with request failed code, '
    'should emit network request failed code',
    build: () => ProfileIdentitiesCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockDeleteUser();
      workoutRepository.mockDeleteAllUserWorkouts();
      healthMeasurementRepository.mockDeleteAllUserMeasurements();
      bloodTestRepository.mockDeleteAllUserTests();
      raceRepository.mockDeleteAllUserRaces();
      authService.mockDeleteAccount(
        throwable: const NetworkException(
          code: NetworkExceptionCode.requestFailed,
        ),
      );
    },
    act: (cubit) => cubit.deleteAccount(),
    expect: () => [
      const ProfileIdentitiesState(status: CubitStatusLoading()),
      const ProfileIdentitiesState(status: CubitStatusNoInternetConnection()),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => workoutRepository.deleteAllUserWorkouts(userId: loggedUserId),
      ).called(1);
      verify(
        () => healthMeasurementRepository.deleteAllUserMeasurements(
          userId: loggedUserId,
        ),
      ).called(1);
      verify(
        () => bloodTestRepository.deleteAllUserTests(userId: loggedUserId),
      ).called(1);
      verify(
        () => raceRepository.deleteAllUserRaces(userId: loggedUserId),
      ).called(1);
      verify(() => userRepository.deleteUser(userId: loggedUserId)).called(1);
      verify(() => authService.deleteAccount()).called(1);
    },
  );

  blocTest(
    'delete account, '
    'unknown exception, '
    'should emit unknown error status and throw exception message',
    build: () => ProfileIdentitiesCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      workoutRepository.mockDeleteAllUserWorkouts();
      bloodTestRepository.mockDeleteAllUserTests();
      healthMeasurementRepository.mockDeleteAllUserMeasurements();
      raceRepository.mockDeleteAllUserRaces();
      userRepository.mockDeleteUser();
      authService.mockDeleteAccount(
        throwable: const UnknownException(message: 'unknown exception message'),
      );
    },
    act: (cubit) => cubit.deleteAccount(),
    expect: () => [
      const ProfileIdentitiesState(status: CubitStatusLoading()),
      const ProfileIdentitiesState(status: CubitStatusUnknownError()),
    ],
    errors: () => [
      const UnknownException(message: 'unknown exception message'),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => userRepository.deleteUser(userId: loggedUserId),
      ).called(1);
      verify(() => authService.deleteAccount()).called(1);
    },
  );

  blocTest(
    'reload logged user, '
    "should call auth service's method to reload logged user",
    build: () => ProfileIdentitiesCubit(),
    setUp: () => authService.mockReloadLoggedUser(),
    act: (cubit) => cubit.reloadLoggedUser(),
    expect: () => [],
    verify: (_) => verify(authService.reloadLoggedUser).called(1),
  );

  blocTest(
    'reload logged user, '
    'network exception with requestFailed code, '
    'should emit no internet connection status',
    build: () => ProfileIdentitiesCubit(),
    setUp: () => authService.mockReloadLoggedUser(
      throwable: const NetworkException(
        code: NetworkExceptionCode.requestFailed,
      ),
    ),
    act: (cubit) => cubit.reloadLoggedUser(),
    expect: () => [
      const ProfileIdentitiesState(status: CubitStatusNoInternetConnection()),
    ],
    verify: (_) => verify(authService.reloadLoggedUser).called(1),
  );
}
