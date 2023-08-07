import '../../dependency_injection.dart';
import '../entity/settings.dart';
import '../entity/user.dart';
import '../repository/user_repository.dart';

class AddUserDataUseCase {
  final UserRepository _userRepository;

  AddUserDataUseCase() : _userRepository = getIt<UserRepository>();

  Future<void> execute({
    required AccountType accountType,
    required String userId,
    required String name,
    required String surname,
    required Gender gender,
  }) async {
    const Settings defaultSettings = Settings(
      themeMode: ThemeMode.system,
      language: Language.english,
      distanceUnit: DistanceUnit.kilometers,
      paceUnit: PaceUnit.minutesPerKilometer,
    );
    //TODO: Implement email
    final User userData = User(
      accountType: accountType,
      id: userId,
      gender: gender,
      name: name,
      surname: surname,
      email: '',
      settings: defaultSettings,
      clientIds: switch (accountType) {
        AccountType.runner => null,
        AccountType.coach => const [],
      },
    );
    await _userRepository.addUser(user: userData);
  }
}
