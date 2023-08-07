import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/repository/user_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';
import 'package:runnoter/domain/use_case/get_logged_user_gender_use_case.dart';

import '../../creators/user_creator.dart';
import '../../mock/domain/repository/mock_user_repository.dart';
import '../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();

  setUpAll(() {
    GetIt.I.registerSingleton<AuthService>(authService);
    GetIt.I.registerSingleton<UserRepository>(userRepository);
  });

  test(
    'should return gender of logged user',
    () {
      const String loggedUserid = 'u1';
      final User user = createUser(
        id: loggedUserid,
        gender: Gender.female,
      );
      authService.mockGetLoggedUserId(userId: loggedUserid);
      userRepository.mockGetUserById(user: user);
      final useCase = GetLoggedUserGenderUseCase();

      final Stream<Gender> gender$ = useCase.execute();

      expect(
        gender$,
        emitsInOrder([Gender.female]),
      );
    },
  );
}
