import '../../data/entity/user.dart';
import '../../dependency_injection.dart';
import '../additional_model/settings.dart';
import '../repository/user_repository.dart';

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
    const Settings defaultSettings = Settings(
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
      settings: defaultSettings,
    );
    await _userRepository.addUser(user: userData);
  }
}
