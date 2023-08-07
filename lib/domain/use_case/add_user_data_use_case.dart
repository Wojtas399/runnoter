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
    String? coachId,
  }) async {
    const Settings defaultSettings = Settings(
      themeMode: ThemeMode.system,
      language: Language.english,
      distanceUnit: DistanceUnit.kilometers,
      paceUnit: PaceUnit.minutesPerKilometer,
    );
    final User userData = switch (accountType) {
      AccountType.coach => Coach(
          id: userId,
          gender: gender,
          name: name,
          surname: surname,
          settings: defaultSettings,
          clientIds: const [],
        ),
      AccountType.runner => Runner(
          id: userId,
          gender: gender,
          name: name,
          surname: surname,
          settings: defaultSettings,
          coachId: coachId,
        ),
    };
    await _userRepository.addUser(user: userData);
  }
}
