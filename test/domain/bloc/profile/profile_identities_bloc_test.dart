import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/auth_exception.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/profile/identities/profile_identities_bloc.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_user_repository.dart';
import '../../../util/user_creator.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();

  ProfileIdentitiesBloc createBloc({
    String? userId,
  }) {
    return ProfileIdentitiesBloc(
      authService: authService,
      userRepository: userRepository,
      userId: userId,
    );
  }

  ProfileIdentitiesState createState({
    BlocStatus status = const BlocStatusInitial(),
    String? userId,
    String? username,
    String? surname,
    String? email,
  }) {
    return ProfileIdentitiesState(
      status: status,
      userId: userId,
      username: username,
      surname: surname,
      email: email,
    );
  }

  tearDown(() {
    reset(authService);
    reset(userRepository);
  });

  blocTest(
    'initialize, '
    'should set listener for logged user email and data',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(
        userId: 'u1',
      );
      authService.mockGetLoggedUserEmail(
        userEmail: 'email@example.com',
      );
      userRepository.mockGetUserById(
        user: createUser(
          id: 'u1',
          name: 'name',
          surname: 'surname',
        ),
      );
    },
    act: (ProfileIdentitiesBloc bloc) {
      bloc.add(
        const ProfileIdentitiesEventInitialize(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        email: 'email@example.com',
      ),
      createState(
        status: const BlocStatusComplete(),
        userId: 'u1',
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
          userId: 'u1',
        ),
      ).called(1);
    },
  );

  blocTest(
    'email updated, '
    'should update email in state',
    build: () => createBloc(),
    act: (ProfileIdentitiesBloc bloc) {
      bloc.add(
        const ProfileIdentitiesEventEmailUpdated(
          email: 'email@example.com',
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        email: 'email@example.com',
      ),
    ],
  );

  blocTest(
    'user updated, '
    'should update user id, username and surname in state',
    build: () => createBloc(),
    act: (ProfileIdentitiesBloc bloc) {
      bloc.add(
        ProfileIdentitiesEventUserUpdated(
          user: createUser(
            id: 'u1',
            name: 'name',
            surname: 'surname',
          ),
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        userId: 'u1',
        username: 'name',
        surname: 'surname',
      ),
    ],
  );

  blocTest(
    'update username, '
    'should call method from user repository to update user and should emit complete status with saved data info',
    build: () => createBloc(
      userId: 'u1',
    ),
    setUp: () {
      userRepository.mockUpdateUserIdentities();
    },
    act: (ProfileIdentitiesBloc bloc) {
      bloc.add(
        const ProfileIdentitiesEventUpdateUsername(
          username: 'new username',
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        userId: 'u1',
      ),
      createState(
        status: const BlocStatusComplete<ProfileInfo>(
          info: ProfileInfo.savedData,
        ),
        userId: 'u1',
      ),
    ],
    verify: (_) {
      verify(
        () => userRepository.updateUserIdentities(
          userId: 'u1',
          name: 'new username',
        ),
      ).called(1);
    },
  );

  blocTest(
    'update username, '
    'user id is null'
    'should do nothing',
    build: () => createBloc(),
    setUp: () {
      userRepository.mockUpdateUserIdentities();
    },
    act: (ProfileIdentitiesBloc bloc) {
      bloc.add(
        const ProfileIdentitiesEventUpdateUsername(
          username: 'new username',
        ),
      );
    },
    expect: () => [],
    verify: (_) {
      verifyNever(
        () => userRepository.updateUserIdentities(
          userId: 'u1',
          name: 'new username',
        ),
      );
    },
  );

  blocTest(
    'update surname, '
    'should call method from user repository to update user and should emit complete status with saved data info',
    build: () => createBloc(
      userId: 'u1',
    ),
    setUp: () {
      userRepository.mockUpdateUserIdentities();
    },
    act: (ProfileIdentitiesBloc bloc) {
      bloc.add(
        const ProfileIdentitiesEventUpdateSurname(
          surname: 'new surname',
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        userId: 'u1',
      ),
      createState(
        status: const BlocStatusComplete<ProfileInfo>(
          info: ProfileInfo.savedData,
        ),
        userId: 'u1',
      ),
    ],
    verify: (_) {
      verify(
        () => userRepository.updateUserIdentities(
          userId: 'u1',
          surname: 'new surname',
        ),
      ).called(1);
    },
  );

  blocTest(
    'update surname, '
    'user id is null'
    'should do nothing',
    build: () => createBloc(),
    setUp: () {
      userRepository.mockUpdateUserIdentities();
    },
    act: (ProfileIdentitiesBloc bloc) {
      bloc.add(
        const ProfileIdentitiesEventUpdateSurname(
          surname: 'new surname',
        ),
      );
    },
    expect: () => [],
    verify: (_) {
      verifyNever(
        () => userRepository.updateUserIdentities(
          userId: 'u1',
          surname: 'new surname',
        ),
      );
    },
  );

  blocTest(
    'update email, '
    'should call method from auth service to update email and should emit complete status with saved data info',
    build: () => createBloc(),
    setUp: () {
      authService.mockUpdateEmail();
    },
    act: (ProfileIdentitiesBloc bloc) {
      bloc.add(
        const ProfileIdentitiesEventUpdateEmail(
          newEmail: 'email@example.com',
          password: 'Password1!',
        ),
      );
    },
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
    verify: (_) {
      verify(
        () => authService.updateEmail(
          newEmail: 'email@example.com',
          password: 'Password1!',
        ),
      ).called(1);
    },
  );

  blocTest(
    'update email, '
    'email already in use auth exception, '
    'should emit error status with email already in use error',
    build: () => createBloc(),
    setUp: () {
      authService.mockUpdateEmail(
        throwable: AuthException.emailAlreadyInUse,
      );
    },
    act: (ProfileIdentitiesBloc bloc) {
      bloc.add(
        const ProfileIdentitiesEventUpdateEmail(
          newEmail: 'email@example.com',
          password: 'Password1!',
        ),
      );
    },
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
    verify: (_) {
      verify(
        () => authService.updateEmail(
          newEmail: 'email@example.com',
          password: 'Password1!',
        ),
      ).called(1);
    },
  );

  blocTest(
    'update email, '
    'wrong password auth exception, '
    'should emit error status with wrong password error',
    build: () => createBloc(),
    setUp: () {
      authService.mockUpdateEmail(
        throwable: AuthException.wrongPassword,
      );
    },
    act: (ProfileIdentitiesBloc bloc) {
      bloc.add(
        const ProfileIdentitiesEventUpdateEmail(
          newEmail: 'email@example.com',
          password: 'Password1!',
        ),
      );
    },
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
    verify: (_) {
      verify(
        () => authService.updateEmail(
          newEmail: 'email@example.com',
          password: 'Password1!',
        ),
      ).called(1);
    },
  );

  blocTest(
    'update email, '
    'unknown exception, '
    'should emit unknown error status and should rethrow exception',
    build: () => createBloc(),
    setUp: () {
      authService.mockUpdateEmail(
        throwable: 'Unknown exception',
      );
    },
    act: (ProfileIdentitiesBloc bloc) {
      bloc.add(
        const ProfileIdentitiesEventUpdateEmail(
          newEmail: 'email@example.com',
          password: 'Password1!',
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusUnknownError(),
      ),
    ],
    errors: () => [
      'Unknown exception',
    ],
    verify: (_) {
      verify(
        () => authService.updateEmail(
          newEmail: 'email@example.com',
          password: 'Password1!',
        ),
      ).called(1);
    },
  );

  blocTest(
    'update password, '
    'should call method from auth service to update password and should emit complete status with saved data info',
    build: () => createBloc(),
    setUp: () {
      authService.mockUpdatePassword();
    },
    act: (ProfileIdentitiesBloc bloc) {
      bloc.add(
        const ProfileIdentitiesEventUpdatePassword(
          newPassword: 'newPassword',
          currentPassword: 'currentPassword',
        ),
      );
    },
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
    verify: (_) {
      verify(
        () => authService.updatePassword(
          newPassword: 'newPassword',
          currentPassword: 'currentPassword',
        ),
      ).called(1);
    },
  );

  blocTest(
    'update password, '
    'wrong password auth exception, '
    'should emit error status with wrong current password error',
    build: () => createBloc(),
    setUp: () {
      authService.mockUpdatePassword(
        throwable: AuthException.wrongPassword,
      );
    },
    act: (ProfileIdentitiesBloc bloc) {
      bloc.add(
        const ProfileIdentitiesEventUpdatePassword(
          newPassword: 'newPassword',
          currentPassword: 'currentPassword',
        ),
      );
    },
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
    verify: (_) {
      verify(
        () => authService.updatePassword(
          newPassword: 'newPassword',
          currentPassword: 'currentPassword',
        ),
      ).called(1);
    },
  );

  blocTest(
    'update password, '
    'unknown exception, '
    'should emit unknown error status and should rethrow exception',
    build: () => createBloc(),
    setUp: () {
      authService.mockUpdatePassword(
        throwable: 'Unknown exception',
      );
    },
    act: (ProfileIdentitiesBloc bloc) {
      bloc.add(
        const ProfileIdentitiesEventUpdatePassword(
          newPassword: 'newPassword',
          currentPassword: 'currentPassword',
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusUnknownError(),
      ),
    ],
    errors: () => [
      'Unknown exception',
    ],
    verify: (_) {
      verify(
        () => authService.updatePassword(
          newPassword: 'newPassword',
          currentPassword: 'currentPassword',
        ),
      ).called(1);
    },
  );

  blocTest(
    'delete account, '
    'userId is null, '
    'should do nothing',
    build: () => createBloc(),
    act: (ProfileIdentitiesBloc bloc) {
      bloc.add(
        const ProfileIdentitiesEventDeleteAccount(
          password: 'password1',
        ),
      );
    },
    expect: () => [],
  );

  blocTest(
    'delete account, '
    'password is correct, '
    'should call methods to delete user data and account and should emit complete status with account deleted info',
    build: () => createBloc(
      userId: 'u1',
    ),
    setUp: () {
      authService.mockIsPasswordCorrect(
        isCorrect: true,
      );
      userRepository.mockDeleteUser();
      authService.mockDeleteAccount();
    },
    act: (ProfileIdentitiesBloc bloc) {
      bloc.add(
        const ProfileIdentitiesEventDeleteAccount(
          password: 'password1',
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        userId: 'u1',
      ),
      createState(
        status: const BlocStatusComplete<ProfileInfo>(
          info: ProfileInfo.accountDeleted,
        ),
        userId: 'u1',
      ),
    ],
    verify: (_) {
      verify(
        () => authService.isPasswordCorrect(
          password: 'password1',
        ),
      ).called(1);
      verify(
        () => userRepository.deleteUser(
          userId: 'u1',
        ),
      ).called(1);
      verify(
        () => authService.deleteAccount(
          password: 'password1',
        ),
      ).called(1);
    },
  );

  blocTest(
    'delete account, '
    'password is incorrect, '
    'should emit error status with wrong password error',
    build: () => createBloc(
      userId: 'u1',
    ),
    setUp: () {
      authService.mockIsPasswordCorrect(
        isCorrect: false,
      );
    },
    act: (ProfileIdentitiesBloc bloc) {
      bloc.add(
        const ProfileIdentitiesEventDeleteAccount(
          password: 'password1',
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        userId: 'u1',
      ),
      createState(
        status: const BlocStatusError<ProfileError>(
          error: ProfileError.wrongPassword,
        ),
        userId: 'u1',
      ),
    ],
    verify: (_) {
      verify(
        () => authService.isPasswordCorrect(
          password: 'password1',
        ),
      ).called(1);
      verifyNever(
        () => userRepository.deleteUser(
          userId: 'u1',
        ),
      );
      verifyNever(
        () => authService.deleteAccount(
          password: 'password1',
        ),
      );
    },
  );

  blocTest(
    'delete account, '
    'unknown exception, '
    'should emit unknown error status and should rethrow error',
    build: () => createBloc(
      userId: 'u1',
    ),
    setUp: () {
      authService.mockIsPasswordCorrect(
        isCorrect: true,
      );
      userRepository.mockDeleteUser();
      authService.mockDeleteAccount(
        throwable: 'Unknown exception...',
      );
    },
    act: (ProfileIdentitiesBloc bloc) {
      bloc.add(
        const ProfileIdentitiesEventDeleteAccount(
          password: 'password1',
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        userId: 'u1',
      ),
      createState(
        status: const BlocStatusUnknownError(),
        userId: 'u1',
      ),
    ],
    errors: () => [
      'Unknown exception...',
    ],
    verify: (_) {
      verify(
        () => authService.isPasswordCorrect(
          password: 'password1',
        ),
      ).called(1);
      verify(
        () => userRepository.deleteUser(
          userId: 'u1',
        ),
      ).called(1);
      verify(
        () => authService.deleteAccount(
          password: 'password1',
        ),
      ).called(1);
    },
  );
}
