import '../../data/model/user.dart';
import '../../data/repository/user/user_repository.dart';
import '../../dependency_injection.dart';

class AddUserDataUseCase {
  final UserRepository _userRepository;

  AddUserDataUseCase() : _userRepository = getIt<UserRepository>();

  Future<void> execute({
    required AccountType accountType,
    required String userId,
    required Gender gender,
    required String name,
    required String surname,
    required String email,
    required DateTime dateOfBirth,
  }) async {
    const UserSettings defaultUserSettings = UserSettings(
      themeMode: ThemeMode.system,
      language: Language.english,
      distanceUnit: DistanceUnit.kilometers,
      paceUnit: PaceUnit.minutesPerKilometer,
    );
    final User userData = User(
      accountType: accountType,
      id: userId,
      gender: gender,
      name: name,
      surname: surname,
      email: email,
      dateOfBirth: dateOfBirth,
      settings: defaultUserSettings,
    );
    await _userRepository.addUser(user: userData);
  }
}
