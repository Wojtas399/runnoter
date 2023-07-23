import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/custom_exception.dart';
import 'package:runnoter/domain/bloc/profile/identities/profile_identities_bloc.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/repository/user_repository.dart';
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

  ProfileIdentitiesState createState({
    BlocStatus status = const BlocStatusInitial(),
    String? loggedUserId,
    Gender? gender,
    String? username,
    String? surname,
    String? email,
  }) {
    return ProfileIdentitiesState(
      status: status,
      loggedUserId: loggedUserId,
      gender: gender,
      username: username,
      surname: surname,
      email: email,
    );
  }

  ProfileIdentitiesBloc createBloc({
    String? loggedUserId,
    Gender? gender,
  }) {
    return ProfileIdentitiesBloc(
      workoutRepository: workoutRepository,
      healthMeasurementRepository: healthMeasurementRepository,
      bloodTestRepository: bloodTestRepository,
      raceRepository: raceRepository,
      state: createState(
        loggedUserId: loggedUserId,
        gender: gender,
      ),
    );
  }

  setUpAll(() {
    GetIt.I.registerSingleton<AuthService>(authService);
    GetIt.I.registerSingleton<UserRepository>(userRepository);
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
    'should set listener of logged user email and data',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
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
      createState(
        status: const BlocStatusComplete(),
        loggedUserId: loggedUserId,
        gender: Gender.female,
        username: 'name',
        surname: 'surname',
        email: 'email@example.com',
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => authService.loggedUserEmail$,
      ).called(1);
      verify(
        () => userRepository.getUserById(
          userId: loggedUserId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'update gender, '
    "should update gender in state and should call method from user repository to update user's data with new gender",
    build: () => createBloc(gender: Gender.male),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUserIdentities();
    },
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdateGender(
      gender: Gender.female,
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        gender: Gender.female,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
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
    build: () => createBloc(gender: Gender.male),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockUpdateUserIdentities(throwable: 'Exception...');
    },
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdateGender(
      gender: Gender.female,
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        gender: Gender.female,
      ),
      createState(
        status: const BlocStatusComplete(),
        gender: Gender.male,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
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
    build: () => createBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdateGender(
      gender: Gender.female,
    )),
    expect: () => [
      createState(
        status: const BlocStatusNoLoggedUser(),
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
    },
  );

  blocTest(
    'update gender, '
    'new gender is the same as current gender, '
    'should do nothing',
    build: () => createBloc(gender: Gender.male),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdateGender(
      gender: Gender.male,
    )),
    expect: () => [],
  );

  blocTest(
    'update username, '
    'should call method from user repository to update user and should emit info that data have been saved',
    build: () => createBloc(loggedUserId: loggedUserId),
    setUp: () => userRepository.mockUpdateUserIdentities(),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdateUsername(
      username: 'new username',
    )),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        loggedUserId: loggedUserId,
      ),
      createState(
        status: const BlocStatusComplete<ProfileInfo>(
          info: ProfileInfo.savedData,
        ),
        loggedUserId: loggedUserId,
      ),
    ],
    verify: (_) => verify(
      () => userRepository.updateUserIdentities(
        userId: loggedUserId,
        name: 'new username',
      ),
    ).called(1),
  );

  blocTest(
    'update username, '
    'user id is null'
    'should do nothing',
    build: () => createBloc(),
    setUp: () => userRepository.mockUpdateUserIdentities(),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdateUsername(
      username: 'new username',
    )),
    expect: () => [],
    verify: (_) => verifyNever(
      () => userRepository.updateUserIdentities(
        userId: loggedUserId,
        name: 'new username',
      ),
    ),
  );

  blocTest(
    'update surname, '
    'should call method from user repository to update user and should emit info that data have been saved',
    build: () => createBloc(loggedUserId: loggedUserId),
    setUp: () => userRepository.mockUpdateUserIdentities(),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdateSurname(
      surname: 'new surname',
    )),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        loggedUserId: loggedUserId,
      ),
      createState(
        status: const BlocStatusComplete<ProfileInfo>(
          info: ProfileInfo.savedData,
        ),
        loggedUserId: loggedUserId,
      ),
    ],
    verify: (_) => verify(
      () => userRepository.updateUserIdentities(
        userId: loggedUserId,
        surname: 'new surname',
      ),
    ).called(1),
  );

  blocTest(
    'update surname, '
    'user id is null'
    'should do nothing',
    build: () => createBloc(),
    setUp: () => userRepository.mockUpdateUserIdentities(),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdateSurname(
      surname: 'new surname',
    )),
    expect: () => [],
    verify: (_) => verifyNever(
      () => userRepository.updateUserIdentities(
        userId: loggedUserId,
        surname: 'new surname',
      ),
    ),
  );

  blocTest(
    'update email, '
    'should call method from auth service to update email and should emit info that data have been saved',
    build: () => createBloc(),
    setUp: () => authService.mockUpdateEmail(),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdateEmail(
      newEmail: 'email@example.com',
      password: 'Password1!',
    )),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusComplete<ProfileInfo>(
          info: ProfileInfo.savedData,
        ),
      ),
    ],
    verify: (_) => verify(
      () => authService.updateEmail(
        newEmail: 'email@example.com',
        password: 'Password1!',
      ),
    ).called(1),
  );

  blocTest(
    'update email, '
    'auth exception with email already in use code, '
    'should emit error status with email already in use error',
    build: () => createBloc(),
    setUp: () => authService.mockUpdateEmail(
      throwable: const AuthException(
        code: AuthExceptionCode.emailAlreadyInUse,
      ),
    ),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdateEmail(
      newEmail: 'email@example.com',
      password: 'Password1!',
    )),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusError<ProfileError>(
          error: ProfileError.emailAlreadyInUse,
        ),
      ),
    ],
    verify: (_) => verify(
      () => authService.updateEmail(
        newEmail: 'email@example.com',
        password: 'Password1!',
      ),
    ).called(1),
  );

  blocTest(
    'update email, '
    'auth exception with wrong password code, '
    'should emit error status with wrong password error',
    build: () => createBloc(),
    setUp: () => authService.mockUpdateEmail(
      throwable: const AuthException(
        code: AuthExceptionCode.wrongPassword,
      ),
    ),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdateEmail(
      newEmail: 'email@example.com',
      password: 'Password1!',
    )),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusError<ProfileError>(
          error: ProfileError.wrongPassword,
        ),
      ),
    ],
    verify: (_) => verify(
      () => authService.updateEmail(
        newEmail: 'email@example.com',
        password: 'Password1!',
      ),
    ).called(1),
  );

  blocTest(
    'update email, '
    'network exception with request failed code, '
    'should emit network request failed status',
    build: () => createBloc(),
    setUp: () => authService.mockUpdateEmail(
      throwable: const NetworkException(
        code: NetworkExceptionCode.requestFailed,
      ),
    ),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdateEmail(
      newEmail: 'email@example.com',
      password: 'Password1!',
    )),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusNetworkRequestFailed(),
      ),
    ],
    verify: (_) => verify(
      () => authService.updateEmail(
        newEmail: 'email@example.com',
        password: 'Password1!',
      ),
    ).called(1),
  );

  blocTest(
    'update email, '
    'unknown exception, '
    'should emit unknown error status and should rethrow exception',
    build: () => createBloc(),
    setUp: () => authService.mockUpdateEmail(
      throwable: const UnknownException(
        message: 'unknown exception message',
      ),
    ),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdateEmail(
      newEmail: 'email@example.com',
      password: 'Password1!',
    )),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusUnknownError(),
      ),
    ],
    errors: () => ['unknown exception message'],
    verify: (_) => verify(
      () => authService.updateEmail(
        newEmail: 'email@example.com',
        password: 'Password1!',
      ),
    ).called(1),
  );

  blocTest(
    'update password, '
    'should call method from auth service to update password and should emit info that data have been saved',
    build: () => createBloc(),
    setUp: () => authService.mockUpdatePassword(),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdatePassword(
      newPassword: 'newPassword',
      currentPassword: 'currentPassword',
    )),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusComplete<ProfileInfo>(
          info: ProfileInfo.savedData,
        ),
      ),
    ],
    verify: (_) => verify(
      () => authService.updatePassword(
        newPassword: 'newPassword',
        currentPassword: 'currentPassword',
      ),
    ).called(1),
  );

  blocTest(
    'update password, '
    'auth exception with wrong password code, '
    'should emit error status with wrong current password error',
    build: () => createBloc(),
    setUp: () => authService.mockUpdatePassword(
      throwable: const AuthException(
        code: AuthExceptionCode.wrongPassword,
      ),
    ),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdatePassword(
      newPassword: 'newPassword',
      currentPassword: 'currentPassword',
    )),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusError<ProfileError>(
          error: ProfileError.wrongCurrentPassword,
        ),
      ),
    ],
    verify: (_) => verify(
      () => authService.updatePassword(
        newPassword: 'newPassword',
        currentPassword: 'currentPassword',
      ),
    ).called(1),
  );

  blocTest(
    'update password, '
    'network exception with request failed code, '
    'should emit network request failed status',
    build: () => createBloc(),
    setUp: () => authService.mockUpdatePassword(
      throwable: const NetworkException(
        code: NetworkExceptionCode.requestFailed,
      ),
    ),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdatePassword(
      newPassword: 'newPassword',
      currentPassword: 'currentPassword',
    )),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusNetworkRequestFailed(),
      ),
    ],
    verify: (_) => verify(
      () => authService.updatePassword(
        newPassword: 'newPassword',
        currentPassword: 'currentPassword',
      ),
    ).called(1),
  );

  blocTest(
    'update password, '
    'unknown exception, '
    'should emit unknown error status',
    build: () => createBloc(),
    setUp: () => authService.mockUpdatePassword(
      throwable: const UnknownException(
        message: 'unknown exception message',
      ),
    ),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventUpdatePassword(
      newPassword: 'newPassword',
      currentPassword: 'currentPassword',
    )),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusUnknownError(),
      ),
    ],
    errors: () => ['unknown exception message'],
    verify: (_) => verify(
      () => authService.updatePassword(
        newPassword: 'newPassword',
        currentPassword: 'currentPassword',
      ),
    ).called(1),
  );

  blocTest(
    'delete account, '
    'userId is null, '
    'should do nothing',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventDeleteAccount(
      password: 'password1',
    )),
    expect: () => [],
  );

  blocTest(
    'delete account, '
    'password is correct, '
    'should call methods to delete user data and account and should emit info that account has been deleted',
    build: () => createBloc(loggedUserId: loggedUserId),
    setUp: () {
      authService.mockIsPasswordCorrect(isCorrect: true);
      authService.mockDeleteAccount();
      userRepository.mockDeleteUser();
      workoutRepository.mockDeleteAllUserWorkouts();
      healthMeasurementRepository.mockDeleteAllUserMeasurements();
      bloodTestRepository.mockDeleteAllUserTests();
      raceRepository.mockDeleteAllUserRaces();
    },
    act: (bloc) => bloc.add(const ProfileIdentitiesEventDeleteAccount(
      password: 'password1',
    )),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        loggedUserId: loggedUserId,
      ),
      createState(
        status: const BlocStatusComplete<ProfileInfo>(
          info: ProfileInfo.accountDeleted,
        ),
        loggedUserId: loggedUserId,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.isPasswordCorrect(password: 'password1'),
      ).called(1);
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
      verify(
        () => userRepository.deleteUser(userId: loggedUserId),
      ).called(1);
      verify(
        () => authService.deleteAccount(password: 'password1'),
      ).called(1);
    },
  );

  blocTest(
    'delete account, '
    'password is incorrect, '
    'should emit error status with wrong password error',
    build: () => createBloc(loggedUserId: loggedUserId),
    setUp: () => authService.mockIsPasswordCorrect(isCorrect: false),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventDeleteAccount(
      password: 'password1',
    )),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        loggedUserId: loggedUserId,
      ),
      createState(
        status: const BlocStatusError<ProfileError>(
          error: ProfileError.wrongPassword,
        ),
        loggedUserId: loggedUserId,
      ),
    ],
    verify: (_) => verify(
      () => authService.isPasswordCorrect(password: 'password1'),
    ).called(1),
  );

  blocTest(
    'delete account, '
    'network exception with request failed code, '
    'should emit network request failed code',
    build: () => createBloc(loggedUserId: loggedUserId),
    setUp: () => authService.mockIsPasswordCorrect(
      throwable: const NetworkException(
        code: NetworkExceptionCode.requestFailed,
      ),
    ),
    act: (bloc) => bloc.add(const ProfileIdentitiesEventDeleteAccount(
      password: 'password1',
    )),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        loggedUserId: loggedUserId,
      ),
      createState(
        status: const BlocStatusNetworkRequestFailed(),
        loggedUserId: loggedUserId,
      ),
    ],
    verify: (_) => verify(
      () => authService.isPasswordCorrect(password: 'password1'),
    ).called(1),
  );

  blocTest(
    'delete account, '
    'unknown exception, '
    'should emit unknown error status and throw exception message',
    build: () => createBloc(loggedUserId: loggedUserId),
    setUp: () {
      authService.mockIsPasswordCorrect(isCorrect: true);
      workoutRepository.mockDeleteAllUserWorkouts();
      bloodTestRepository.mockDeleteAllUserTests();
      healthMeasurementRepository.mockDeleteAllUserMeasurements();
      raceRepository.mockDeleteAllUserRaces();
      userRepository.mockDeleteUser();
      authService.mockDeleteAccount(
        throwable: const UnknownException(
          message: 'unknown exception message',
        ),
      );
    },
    act: (bloc) => bloc.add(const ProfileIdentitiesEventDeleteAccount(
      password: 'password1',
    )),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        loggedUserId: loggedUserId,
      ),
      createState(
        status: const BlocStatusUnknownError(),
        loggedUserId: loggedUserId,
      ),
    ],
    errors: () => ['unknown exception message'],
    verify: (_) {
      verify(
        () => authService.isPasswordCorrect(password: 'password1'),
      ).called(1);
      verify(
        () => userRepository.deleteUser(userId: loggedUserId),
      ).called(1);
      verify(
        () => authService.deleteAccount(password: 'password1'),
      ).called(1);
    },
  );
}
