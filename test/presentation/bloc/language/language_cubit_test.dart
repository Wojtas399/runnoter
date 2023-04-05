import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/settings.dart';
import 'package:runnoter/presentation/screen/language/language_cubit.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_user_repository.dart';
import '../../../util/settings_creator.dart';
import '../../../util/user_creator.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();

  LanguageCubit createCubit() {
    return LanguageCubit(
      authService: authService,
      userRepository: userRepository,
    );
  }

  blocTest(
    'initialize, '
    'should load logged user and should update language in state',
    build: () => createCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(
        userId: 'u1',
      );
      userRepository.mockGetUserById(
        user: createUser(
          id: 'u1',
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
          userId: 'u1',
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
}
