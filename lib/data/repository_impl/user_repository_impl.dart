import 'package:firebase/firebase.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/model/state_repository.dart';
import '../../domain/model/user.dart';
import '../../domain/repository/user_repository.dart';
import '../mapper/settings_mapper.dart';
import '../mapper/user_mapper.dart';

class UserRepositoryImpl extends StateRepository<User>
    implements UserRepository {
  final FirebaseUserService _firebaseUserService;
  final FirebaseAppearanceSettingsService _firebaseAppearanceSettingsService;
  final FirebaseWorkoutSettingsService _firebaseWorkoutSettingsService;

  UserRepositoryImpl({
    required FirebaseUserService firebaseUserService,
    required FirebaseAppearanceSettingsService
        firebaseAppearanceSettingsService,
    required FirebaseWorkoutSettingsService firebaseWorkoutSettingsService,
    List<User>? initialState,
  })  : _firebaseUserService = firebaseUserService,
        _firebaseAppearanceSettingsService = firebaseAppearanceSettingsService,
        _firebaseWorkoutSettingsService = firebaseWorkoutSettingsService,
        super(
          initialData: initialState,
        );

  @override
  Stream<User?> getUserById({
    required String userId,
  }) {
    return dataStream$
        .map(
      (List<User>? users) => <User?>[...?users].firstWhere(
        (User? user) => user?.id == userId,
        orElse: () => null,
      ),
    )
        .doOnListen(
      () async {
        if (doesEntityNotExistInState(userId)) {
          await _loadUserFromFirebase(userId);
        }
      },
    );
  }

  @override
  Future<void> addUser({
    required User user,
  }) async {
    await _firebaseUserService.addUserPersonalData(
      userDto: UserDto(
        id: user.id,
        name: user.name,
        surname: user.surname,
      ),
    );
    await _firebaseAppearanceSettingsService.addSettings(
      appearanceSettingsDto: AppearanceSettingsDto(
        userId: user.id,
        themeMode: mapThemeModeToDb(user.settings.themeMode),
        language: mapLanguageToDb(user.settings.language),
      ),
    );
    await _firebaseWorkoutSettingsService.addSettings(
      workoutSettingsDto: WorkoutSettingsDto(
        userId: user.id,
        distanceUnit: mapDistanceUnitToDb(user.settings.distanceUnit),
        paceUnit: mapPaceUnitToDb(user.settings.paceUnit),
      ),
    );
    addEntity(user);
  }

  @override
  Future<void> updateUser({
    required String userId,
    String? name,
    String? surname,
  }) async {
    final UserDto? userDto = await _firebaseUserService.updateUserData(
      userId: userId,
      name: name,
      surname: surname,
    );
    if (userDto != null) {
      final User user = mapUserFromDto(
        userDto: userDto,
        appearanceSettingsDto: const AppearanceSettingsDto(
          userId: '',
          themeMode: ThemeMode.light,
          language: Language.polish,
        ),
        workoutSettingsDto: const WorkoutSettingsDto(
          userId: '',
          distanceUnit: DistanceUnit.kilometers,
          paceUnit: PaceUnit.minutesPerKilometer,
        ),
      );
      if (doesEntityNotExistInState(user.id)) {
        addEntity(user);
      } else {
        updateEntity(user);
      }
    }
  }

  @override
  Future<void> deleteUser({
    required String userId,
  }) async {
    await _firebaseUserService.deleteUserData(userId: userId);
    removeEntity(userId);
  }

  Future<void> _loadUserFromFirebase(String userId) async {
    final UserDto? userDto = await _firebaseUserService.loadUserById(
      userId: userId,
    );
    final AppearanceSettingsDto? appearanceSettingsDto =
        await _firebaseAppearanceSettingsService.loadSettingsByUserId(
      userId: userId,
    );
    final WorkoutSettingsDto? workoutSettingsDto =
        await _firebaseWorkoutSettingsService.loadSettingsByUserId(
      userId: userId,
    );
    if (userDto != null &&
        appearanceSettingsDto != null &&
        workoutSettingsDto != null) {
      final User user = mapUserFromDto(
        userDto: userDto,
        appearanceSettingsDto: appearanceSettingsDto,
        workoutSettingsDto: workoutSettingsDto,
      );
      addEntity(user);
    }
  }
}
