import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/custom_exception.dart';
import 'package:runnoter/domain/bloc/profile/identities/profile_identities_bloc.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/repository/blood_test_repository.dart';
import 'package:runnoter/domain/repository/health_measurement_repository.dart';
import 'package:runnoter/domain/repository/race_repository.dart';
import 'package:runnoter/domain/repository/user_repository.dart';
import 'package:runnoter/domain/repository/workout_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';

import '../../../../creators/user_creator.dart';
import '../../../../mock/domain/repository/mock_blood_test_repository.dart';
import '../../../../mock/domain/repository/mock_health_measurement_repository.dart';
import '../../../../mock/domain/repository/mock_race_repository.dart';
import '../../../../mock/domain/repository/mock_user_repository.dart';
import '../../../../mock/domain/repository/mock_workout_repository.dart';
import '../../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();
  final workoutRepository = MockWorkoutRepository();
  final healthMeasurementRepository = MockHealthMeasurementRepository();
  final bloodTestRepository = MockBloodTestRepository();
  final raceRepository = MockRaceRepository();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerSingleton<AuthService>(authService);
    GetIt.I.registerSingleton<UserRepository>(userRepository);
    GetIt.I.registerSingleton<WorkoutRepository>(workoutRepository);
    GetIt.I.registerSingleton<HealthMeasurementRepository>(
      healthMeasurementRepository,
    );
    GetIt.I.registerSingleton<BloodTestRepository>(bloodTestRepository);
    GetIt.I.registerSingleton<RaceRepository>(raceRepository);
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
    build: () => ProfileIdentitiesBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      authService.mockHasLoggedUserVerifiedEmail(expected: true);
      authService.mockGetLoggedUserEmail(userEmail: 'email@example.com');
      userRepository.mockGetUserById(
        user: createUser(
          id: loggedUserId,
          gender: Gender.female,
          name: 'name',
          surname: 'surname',
        ),
      );
    },
    act: (bloc) => bloc.add(const ProfileIdentitiesEventInitialize()),
    expect: () => [
      const ProfileIdentitiesState(
        status: BlocStatusComplete(),
        gender: Gender.female,
        username: 'name',
        surname: 'surname',
        email: 'email@example.com',
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
    build: () => ProfileIdentitiesBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUserIdentities();
    },
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdateGender(
      gender: Gender.female,
    )),
    expect: () => [
      const ProfileIdentitiesState(
        status: BlocStatusComplete(),
        gender: Gender.female,
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => userRepository.updateUserIdentities(
          userId: loggedUserId,
          gender: Gender.female,
        ),
      ).called(1);
    },
  );

  blocTest(
    'update gender, '
    'method from user repository to update identities throws exception, '
    'should set previous gender',
    build: () => ProfileIdentitiesBloc(
      state: const ProfileIdentitiesState(
        status: BlocStatusInitial(),
        gender: Gender.male,
      ),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUserIdentities(throwable: 'Exception...');
    },
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdateGender(
      gender: Gender.female,
    )),
    expect: () => [
      const ProfileIdentitiesState(
        status: BlocStatusComplete(),
        gender: Gender.female,
      ),
      const ProfileIdentitiesState(
        status: BlocStatusComplete(),
        gender: Gender.male,
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => userRepository.updateUserIdentities(
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
    build: () => ProfileIdentitiesBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdateGender(
      gender: Gender.female,
    )),
    expect: () => [
      const ProfileIdentitiesState(status: BlocStatusNoLoggedUser()),
    ],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'update gender, '
    'new gender is the same as current gender, '
    'should do nothing',
    build: () => ProfileIdentitiesBloc(
      state: const ProfileIdentitiesState(
        status: BlocStatusInitial(),
        gender: Gender.male,
      ),
    ),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdateGender(
      gender: Gender.male,
    )),
    expect: () => [],
  );

  blocTest(
    'update username, '
    'should call method from user repository to update user and should emit info that data have been saved',
    build: () => ProfileIdentitiesBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUserIdentities();
    },
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdateUsername(
      username: 'new username',
    )),
    expect: () => [
      const ProfileIdentitiesState(status: BlocStatusLoading()),
      const ProfileIdentitiesState(
        status: BlocStatusComplete<ProfileIdentitiesBlocInfo>(
            info: ProfileIdentitiesBlocInfo.dataSaved),
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => userRepository.updateUserIdentities(
          userId: loggedUserId,
          name: 'new username',
        ),
      ).called(1);
    },
  );

  blocTest(
    'update username, '
    'logged user does not exist, '
    'should emit no logged user status',
    build: () => ProfileIdentitiesBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdateUsername(
      username: 'new username',
    )),
    expect: () => [
      const ProfileIdentitiesState(status: BlocStatusNoLoggedUser()),
    ],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'update surname, '
    'should call method from user repository to update user and should emit info that data have been saved',
    build: () => ProfileIdentitiesBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUserIdentities();
    },
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdateSurname(
      surname: 'new surname',
    )),
    expect: () => [
      const ProfileIdentitiesState(status: BlocStatusLoading()),
      const ProfileIdentitiesState(
        status: BlocStatusComplete<ProfileIdentitiesBlocInfo>(
            info: ProfileIdentitiesBlocInfo.dataSaved),
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => userRepository.updateUserIdentities(
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
    build: () => ProfileIdentitiesBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdateSurname(
      surname: 'new surname',
    )),
    expect: () => [
      const ProfileIdentitiesState(status: BlocStatusNoLoggedUser()),
    ],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'update email, '
    'should call method from auth service to update email and to send email verification and should emit emailChanged info',
    build: () => ProfileIdentitiesBloc(),
    setUp: () {
      authService.mockUpdateEmail();
      authService.mockSendEmailVerification();
    },
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdateEmail(
      newEmail: 'email@example.com',
    )),
    expect: () => [
      const ProfileIdentitiesState(status: BlocStatusLoading()),
      const ProfileIdentitiesState(
        status: BlocStatusComplete<ProfileIdentitiesBlocInfo>(
          info: ProfileIdentitiesBlocInfo.emailChanged,
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => authService.updateEmail(newEmail: 'email@example.com'),
      ).called(1);
      verify(authService.sendEmailVerification).called(1);
    },
  );

  blocTest(
    'update email, '
    'auth exception with email already in use code, '
    'should emit error status with email already in use error',
    build: () => ProfileIdentitiesBloc(),
    setUp: () => authService.mockUpdateEmail(
      throwable: const AuthException(
        code: AuthExceptionCode.emailAlreadyInUse,
      ),
    ),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdateEmail(
      newEmail: 'email@example.com',
    )),
    expect: () => [
      const ProfileIdentitiesState(status: BlocStatusLoading()),
      const ProfileIdentitiesState(
        status: BlocStatusError<ProfileIdentitiesBlocError>(
          error: ProfileIdentitiesBlocError.emailAlreadyInUse,
        ),
      ),
    ],
    verify: (_) => verify(
      () => authService.updateEmail(newEmail: 'email@example.com'),
    ).called(1),
  );

  blocTest(
    'update email, '
    'network exception with request failed code, '
    'should emit network request failed status',
    build: () => ProfileIdentitiesBloc(),
    setUp: () => authService.mockUpdateEmail(
      throwable: const NetworkException(
        code: NetworkExceptionCode.requestFailed,
      ),
    ),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdateEmail(
      newEmail: 'email@example.com',
    )),
    expect: () => [
      const ProfileIdentitiesState(status: BlocStatusLoading()),
      const ProfileIdentitiesState(status: BlocStatusNoInternetConnection()),
    ],
    verify: (_) => verify(
      () => authService.updateEmail(newEmail: 'email@example.com'),
    ).called(1),
  );

  blocTest(
    'update email, '
    'unknown exception, '
    'should emit unknown error status and should rethrow exception',
    build: () => ProfileIdentitiesBloc(),
    setUp: () => authService.mockUpdateEmail(
      throwable: const UnknownException(message: 'unknown exception message'),
    ),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdateEmail(
      newEmail: 'email@example.com',
    )),
    expect: () => [
      const ProfileIdentitiesState(status: BlocStatusLoading()),
      const ProfileIdentitiesState(status: BlocStatusUnknownError()),
    ],
    errors: () => ['unknown exception message'],
    verify: (_) => verify(
      () => authService.updateEmail(newEmail: 'email@example.com'),
    ).called(1),
  );

  blocTest(
    'send email verification, '
    "should call auth service's method to send email verification and should emit emailVerificationSent info",
    build: () => ProfileIdentitiesBloc(),
    setUp: () => authService.mockSendEmailVerification(),
    act: (bloc) => bloc.add(
      const ProfileIdentitiesEventSendEmailVerification(),
    ),
    expect: () => [
      const ProfileIdentitiesState(status: BlocStatusLoading()),
      const ProfileIdentitiesState(
        status: BlocStatusComplete<ProfileIdentitiesBlocInfo>(
          info: ProfileIdentitiesBlocInfo.emailVerificationSent,
        ),
      ),
    ],
    verify: (_) => verify(authService.sendEmailVerification).called(1),
  );

  blocTest(
    'update password, '
    'should call method from auth service to update password and should emit info that data have been saved',
    build: () => ProfileIdentitiesBloc(),
    setUp: () => authService.mockUpdatePassword(),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdatePassword(
      newPassword: 'newPassword',
    )),
    expect: () => [
      const ProfileIdentitiesState(status: BlocStatusLoading()),
      const ProfileIdentitiesState(
        status: BlocStatusComplete<ProfileIdentitiesBlocInfo>(
            info: ProfileIdentitiesBlocInfo.dataSaved),
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
    build: () => ProfileIdentitiesBloc(),
    setUp: () => authService.mockUpdatePassword(
      throwable: const NetworkException(
        code: NetworkExceptionCode.requestFailed,
      ),
    ),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdatePassword(
      newPassword: 'newPassword',
    )),
    expect: () => [
      const ProfileIdentitiesState(status: BlocStatusLoading()),
      const ProfileIdentitiesState(status: BlocStatusNoInternetConnection()),
    ],
    verify: (_) => verify(
      () => authService.updatePassword(newPassword: 'newPassword'),
    ).called(1),
  );

  blocTest(
    'update password, '
    'unknown exception, '
    'should emit unknown error status',
    build: () => ProfileIdentitiesBloc(),
    setUp: () => authService.mockUpdatePassword(
      throwable: const UnknownException(message: 'unknown exception message'),
    ),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdatePassword(
      newPassword: 'newPassword',
    )),
    expect: () => [
      const ProfileIdentitiesState(status: BlocStatusLoading()),
      const ProfileIdentitiesState(status: BlocStatusUnknownError()),
    ],
    errors: () => ['unknown exception message'],
    verify: (_) => verify(
      () => authService.updatePassword(newPassword: 'newPassword'),
    ).called(1),
  );

  blocTest(
    'delete account, '
    'logged user does not exist, '
    'should emit no logged user status',
    build: () => ProfileIdentitiesBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventDeleteAccount()),
    expect: () => [
      const ProfileIdentitiesState(status: BlocStatusNoLoggedUser()),
    ],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'delete account, '
    'should call methods to delete user data and account and should emit info that account has been deleted',
    build: () => ProfileIdentitiesBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      authService.mockDeleteAccount();
      userRepository.mockDeleteUser();
      workoutRepository.mockDeleteAllUserWorkouts();
      healthMeasurementRepository.mockDeleteAllUserMeasurements();
      bloodTestRepository.mockDeleteAllUserTests();
      raceRepository.mockDeleteAllUserRaces();
    },
    act: (bloc) => bloc.add(const ProfileIdentitiesEventDeleteAccount()),
    expect: () => [
      const ProfileIdentitiesState(status: BlocStatusLoading()),
      const ProfileIdentitiesState(
        status: BlocStatusComplete<ProfileIdentitiesBlocInfo>(
          info: ProfileIdentitiesBlocInfo.accountDeleted,
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
      verify(() => authService.deleteAccount()).called(1);
    },
  );

  blocTest(
    'delete account, '
    'network exception with request failed code, '
    'should emit network request failed code',
    build: () => ProfileIdentitiesBloc(),
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
    act: (bloc) => bloc.add(const ProfileIdentitiesEventDeleteAccount()),
    expect: () => [
      const ProfileIdentitiesState(status: BlocStatusLoading()),
      const ProfileIdentitiesState(status: BlocStatusNoInternetConnection()),
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
    build: () => ProfileIdentitiesBloc(),
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
    act: (bloc) => bloc.add(const ProfileIdentitiesEventDeleteAccount()),
    expect: () => [
      const ProfileIdentitiesState(status: BlocStatusLoading()),
      const ProfileIdentitiesState(status: BlocStatusUnknownError()),
    ],
    errors: () => ['unknown exception message'],
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
    build: () => ProfileIdentitiesBloc(),
    setUp: () => authService.mockReloadLoggedUser(),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventReloadLoggedUser()),
    expect: () => [],
    verify: (_) => verify(authService.reloadLoggedUser).called(1),
  );

  blocTest(
    'reload logged user, '
    'network exception with requestFailed code, '
    'should emit no internet connection status',
    build: () => ProfileIdentitiesBloc(),
    setUp: () => authService.mockReloadLoggedUser(
      throwable: const NetworkException(
        code: NetworkExceptionCode.requestFailed,
      ),
    ),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventReloadLoggedUser()),
    expect: () => [
      const ProfileIdentitiesState(status: BlocStatusNoInternetConnection()),
    ],
    verify: (_) => verify(authService.reloadLoggedUser).called(1),
  );
}
