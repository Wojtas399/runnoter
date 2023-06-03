import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/entity/settings.dart';
import 'package:runnoter/presentation/screen/language/language_cubit.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_user_repository.dart';
import '../../../util/settings_creator.dart';
import '../../../util/user_creator.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();
  const String userId = 'u1';

  LanguageCubit createCubit({
    Language? language,
  }) {
    return LanguageCubit(
      authService: authService,
      userRepository: userRepository,
      language: language,
    );
  }

  tearDown(() {
    reset(authService);
    reset(userRepository);
  });

  blocTest(
    'initialize, '
    'should load logged user and should update language in state',
    build: () => createCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(
        userId: userId,
      );
      userRepository.mockGetUserById(
        user: createUser(
          id: userId,
          settings: createSettings(
            language: Language.english,
          ),
        ),
      );
    },
    act: (LanguageCubit cubit) {
      cubit.initialize();
    },
    expect: () => [
      Language.english,
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => userRepository.getUserById(
          userId: userId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should end initializing process',
    build: () => createCubit(),
    setUp: () {
      authService.mockGetLoggedUserId();
    },
    act: (LanguageCubit cubit) {
      cubit.initialize();
    },
    expect: () => [],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verifyNever(
        () => userRepository.getUserById(
          userId: any(named: 'userId'),
        ),
      );
    },
  );

  blocTest(
    'update language, '
    "should update language mode in state and should call method from user repository to update user's settings",
    build: () => createCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(
        userId: userId,
      );
      userRepository.mockUpdateUserSettings();
    },
    act: (LanguageCubit cubit) {
      cubit.updateLanguage(
        newLanguage: Language.english,
      );
    },
    expect: () => [
      Language.english,
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => userRepository.updateUserSettings(
          userId: userId,
          language: Language.english,
        ),
      ).called(1);
    },
  );

  blocTest(
    'update language, '
    "method from user repository to update user's settings throws exception, "
    'should set previous language',
    build: () => createCubit(
      language: Language.polish,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(
        userId: userId,
      );
      userRepository.mockUpdateUserSettings(
        throwable: 'Exception...',
      );
    },
    act: (LanguageCubit cubit) {
      cubit.updateLanguage(
        newLanguage: Language.english,
      );
    },
    expect: () => [
      Language.english,
      Language.polish,
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => userRepository.updateUserSettings(
          userId: userId,
          language: Language.english,
        ),
      ).called(1);
    },
  );

  blocTest(
    'update language, '
    'logged user does not exist, '
    'should finish method call without changing anything',
    build: () => createCubit(),
    setUp: () {
      authService.mockGetLoggedUserId();
    },
    act: (LanguageCubit cubit) {
      cubit.updateLanguage(
        newLanguage: Language.english,
      );
    },
    expect: () => [],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verifyNever(
        () => userRepository.updateUserSettings(
          userId: userId,
          language: any(named: 'language'),
        ),
      );
    },
  );

  blocTest(
    'update language, '
    'new language is the same as current language, '
    'should do nothing',
    build: () => createCubit(
      language: Language.english,
    ),
    act: (LanguageCubit cubit) {
      cubit.updateLanguage(
        newLanguage: Language.english,
      );
    },
    expect: () => [],
    verify: (_) {
      verifyNever(
        () => authService.loggedUserId$,
      );
      verifyNever(
        () => userRepository.updateUserSettings(
          userId: any(named: 'userId'),
          language: any(named: 'language'),
        ),
      );
    },
  );
}
