import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/cubit/clients_cubit.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/entity/user_basic_info.dart';
import 'package:runnoter/domain/repository/user_basic_info_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';

import '../../mock/domain/repository/mock_user_basic_info_repository.dart';
import '../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final userBasicInfoRepository = MockUserBasicInfoRepository();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerLazySingleton<UserBasicInfoRepository>(
      () => userBasicInfoRepository,
    );
  });

  tearDown(() {
    reset(authService);
    reset(userBasicInfoRepository);
  });

  blocTest(
    'initialize, '
    'should get users by coach id from user basic info repository and should emit them',
    build: () => ClientsCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userBasicInfoRepository.mockGetUsersBasicInfoByCoachId(
        usersBasicInfo: const [
          UserBasicInfo(
            id: 'u3',
            gender: Gender.female,
            name: 'Elizabeth',
            surname: 'Bobsly',
            email: 'elizabeth.bobsly@example.com',
          ),
          UserBasicInfo(
            id: 'u4',
            gender: Gender.female,
            name: 'Elizabeth',
            surname: 'Bugly',
            email: 'elizabeth.bug@example.com',
          ),
          UserBasicInfo(
            id: 'u2',
            gender: Gender.male,
            name: 'Jack',
            surname: 'Novosilsky',
            email: 'jack.nov@example.com',
          ),
        ],
      );
    },
    act: (cubit) => cubit.initialize(),
    expect: () => [
      const [
        UserBasicInfo(
          id: 'u3',
          gender: Gender.female,
          name: 'Elizabeth',
          surname: 'Bobsly',
          email: 'elizabeth.bobsly@example.com',
        ),
        UserBasicInfo(
          id: 'u4',
          gender: Gender.female,
          name: 'Elizabeth',
          surname: 'Bugly',
          email: 'elizabeth.bug@example.com',
        ),
        UserBasicInfo(
          id: 'u2',
          gender: Gender.male,
          name: 'Jack',
          surname: 'Novosilsky',
          email: 'jack.nov@example.com',
        ),
      ],
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => userBasicInfoRepository.getUsersBasicInfoByCoachId(
          coachId: loggedUserId,
        ),
      ).called(1);
    },
  );
}
