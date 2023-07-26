import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/entity/settings.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/repository/user_repository.dart';
import 'package:runnoter/domain/use_case/set_initial_user_settings_use_case.dart';

import '../../creators/user_creator.dart';
import '../../mock/domain/repository/mock_user_repository.dart';

void main() {
  final userRepository = MockUserRepository();

  setUpAll(() {
    GetIt.I.registerSingleton<UserRepository>(userRepository);
  });

  test(
    'should call method from user repository to add new user with default settings',
    () async {
      const String userId = 'u1';
      const String name = 'Jack';
      const String surname = 'Novsky';
      const Gender gender = Gender.male;
      const defaultSettings = Settings(
        themeMode: ThemeMode.system,
        language: Language.english,
        distanceUnit: DistanceUnit.kilometers,
        paceUnit: PaceUnit.minutesPerKilometer,
      );
      final User user = createUser(
        id: userId,
        name: name,
        surname: surname,
        gender: gender,
        settings: defaultSettings,
      );
      userRepository.mockAddUser();
      final useCase = SetInitialUserSettingsUseCase();

      await useCase.execute(
        userId: userId,
        name: name,
        surname: surname,
        gender: gender,
      );

      verify(
        () => userRepository.addUser(user: user),
      ).called(1);
    },
  );
}
