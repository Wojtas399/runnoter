import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/settings.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/repository/user_repository.dart';
import 'package:runnoter/domain/use_case/add_user_data_use_case.dart';

import '../../mock/domain/repository/mock_user_repository.dart';

void main() {
  final userRepository = MockUserRepository();
  const String userId = 'u1';
  const AccountType accountType = AccountType.coach;
  const Gender gender = Gender.male;
  const String name = 'Jack';
  const String surname = 'Novsky';
  const String email = 'email@example.com';
  const defaultSettings = Settings(
    themeMode: ThemeMode.system,
    language: Language.english,
    distanceUnit: DistanceUnit.kilometers,
    paceUnit: PaceUnit.minutesPerKilometer,
  );

  setUpAll(() {
    GetIt.I.registerSingleton<UserRepository>(userRepository);
  });

  test(
    'should call method from user repository to add new user with clientIds param set as empty array',
    () async {
      final useCase = AddUserDataUseCase();
      const User user = User(
        id: userId,
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        settings: defaultSettings,
      );
      userRepository.mockAddUser();

      await useCase.execute(
        accountType: accountType,
        userId: userId,
        name: name,
        surname: surname,
        email: email,
        gender: gender,
      );

      verify(() => userRepository.addUser(user: user)).called(1);
    },
  );
}
