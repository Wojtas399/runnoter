import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/entity/settings.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/repository/user_repository.dart';
import 'package:runnoter/domain/use_case/add_user_data_use_case.dart';

import '../../mock/domain/repository/mock_user_repository.dart';

void main() {
  final userRepository = MockUserRepository();
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
  late AddUserDataUseCase useCase;

  setUpAll(() {
    GetIt.I.registerSingleton<UserRepository>(userRepository);
  });

  setUp(() {
    useCase = AddUserDataUseCase();
  });

  tearDown(() {
    reset(userRepository);
  });

  test(
    'coach, '
    'should call method from user repository to add new coach with default settings',
    () async {
      const User user = Coach(
        id: userId,
        gender: gender,
        name: name,
        surname: surname,
        settings: defaultSettings,
        idsOfRunners: [],
      );
      userRepository.mockAddUser();

      await useCase.execute(
        accountType: AccountType.coach,
        userId: userId,
        name: name,
        surname: surname,
        gender: gender,
      );

      verify(() => userRepository.addUser(user: user)).called(1);
    },
  );

  test(
    'runner, '
    'should call method from user repository to add new runner with default settings',
    () async {
      const User user = Runner(
        id: userId,
        gender: gender,
        name: name,
        surname: surname,
        settings: defaultSettings,
        coachId: 'c1',
      );
      userRepository.mockAddUser();

      await useCase.execute(
        accountType: AccountType.runner,
        userId: userId,
        name: name,
        surname: surname,
        gender: gender,
        coachId: 'c1',
      );

      verify(() => userRepository.addUser(user: user)).called(1);
    },
  );
}
