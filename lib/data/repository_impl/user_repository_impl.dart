import 'package:collection/collection.dart';
import 'package:firebase/firebase.dart';

import '../../domain/additional_model/state_repository.dart';
import '../../domain/entity/settings.dart' as settings;
import '../../domain/entity/user.dart';
import '../../domain/repository/user_repository.dart';
import '../mapper/settings_mapper.dart';
import '../mapper/user_mapper.dart';

class UserRepositoryImpl extends StateRepository<User>
    implements UserRepository {
  final FirebaseUserService _dbUserService;
  final FirebaseAppearanceSettingsService _dbAppearanceSettingsService;
  final FirebaseWorkoutSettingsService _dbWorkoutSettingsService;

  UserRepositoryImpl({
    required FirebaseUserService firebaseUserService,
    required FirebaseAppearanceSettingsService
        firebaseAppearanceSettingsService,
    required FirebaseWorkoutSettingsService firebaseWorkoutSettingsService,
    List<User>? initialState,
  })  : _dbUserService = firebaseUserService,
        _dbAppearanceSettingsService = firebaseAppearanceSettingsService,
        _dbWorkoutSettingsService = firebaseWorkoutSettingsService,
        super(initialData: initialState);

  @override
  Stream<User?> getUserById({
    required String userId,
  }) async* {
    await for (final users in dataStream$) {
      User? user = users?.firstWhereOrNull(
        (User? user) => user?.id == userId,
      );
      user ??= await _loadUserFromDb(userId);
      yield user;
    }
  }

  @override
  Future<void> addUser({
    required User user,
  }) async {
    await _dbUserService.addUserPersonalData(
      userDto: UserDto(
        id: user.id,
        name: user.name,
        surname: user.surname,
      ),
    );
    await _dbAppearanceSettingsService.addSettings(
      appearanceSettingsDto: AppearanceSettingsDto(
        userId: user.id,
        themeMode: mapThemeModeToDb(user.settings.themeMode),
        language: mapLanguageToDb(user.settings.language),
      ),
    );
    await _dbWorkoutSettingsService.addSettings(
      workoutSettingsDto: WorkoutSettingsDto(
        userId: user.id,
        distanceUnit: mapDistanceUnitToDb(user.settings.distanceUnit),
        paceUnit: mapPaceUnitToDb(user.settings.paceUnit),
      ),
    );
    addEntity(user);
  }

  @override
  Future<void> updateUserIdentities({
    required String userId,
    String? name,
    String? surname,
  }) async {
    final Stream<User?> user$ = getUserById(userId: userId);
    await for (final user in user$) {
      if (user == null) return;
      final UserDto? updatedUserDto = await _dbUserService.updateUserData(
        userId: userId,
        name: name,
        surname: surname,
      );
      if (updatedUserDto == null) return;
      final User updatedUser = User(
        id: userId,
        name: updatedUserDto.name,
        surname: updatedUserDto.surname,
        settings: user.settings,
      );
      updateEntity(updatedUser);
      return;
    }
  }

  @override
  Future<void> updateUserSettings({
    required String userId,
    settings.ThemeMode? themeMode,
    settings.Language? language,
    settings.DistanceUnit? distanceUnit,
    settings.PaceUnit? paceUnit,
  }) async {
    final Stream<User?> user$ = getUserById(userId: userId);
    await for (final user in user$) {
      if (user == null) return;
      AppearanceSettingsDto? newAppearanceSettingsDto;
      WorkoutSettingsDto? newWorkoutSettingsDto;
      if (themeMode != null || language != null) {
        newAppearanceSettingsDto =
            await _updateAppearanceSettings(userId, themeMode, language);
      }
      if (distanceUnit != null || paceUnit != null) {
        newWorkoutSettingsDto =
            await _updateWorkoutSettings(userId, distanceUnit, paceUnit);
      }
      if (newAppearanceSettingsDto == null && newWorkoutSettingsDto == null) {
        return;
      }
      final settings.Settings updatedSettings = settings.Settings(
        themeMode: newAppearanceSettingsDto != null
            ? mapThemeModeFromDb(newAppearanceSettingsDto.themeMode)
            : user.settings.themeMode,
        language: newAppearanceSettingsDto != null
            ? mapLanguageFromDb(newAppearanceSettingsDto.language)
            : user.settings.language,
        distanceUnit: newWorkoutSettingsDto != null
            ? mapDistanceUnitFromDb(newWorkoutSettingsDto.distanceUnit)
            : user.settings.distanceUnit,
        paceUnit: newWorkoutSettingsDto != null
            ? mapPaceUnitFromDb(newWorkoutSettingsDto.paceUnit)
            : user.settings.paceUnit,
      );
      final User updatedUser = User(
        id: user.id,
        name: user.name,
        surname: user.surname,
        settings: updatedSettings,
      );
      updateEntity(updatedUser);
      return;
    }
  }

  @override
  Future<void> deleteUser({
    required String userId,
  }) async {
    await _dbAppearanceSettingsService.deleteSettingsForUser(userId: userId);
    await _dbWorkoutSettingsService.deleteSettingsForUser(userId: userId);
    await _dbUserService.deleteUserData(userId: userId);
    removeEntity(userId);
  }

  Future<User?> _loadUserFromDb(String userId) async {
    final UserDto? userDto = await _dbUserService.loadUserById(userId: userId);
    if (userDto == null) return null;
    final AppearanceSettingsDto? appearanceSettingsDto =
        await _dbAppearanceSettingsService.loadSettingsByUserId(userId: userId);
    final WorkoutSettingsDto? workoutSettingsDto =
        await _dbWorkoutSettingsService.loadSettingsByUserId(userId: userId);
    if (appearanceSettingsDto != null && workoutSettingsDto != null) {
      final User user = mapUserFromDto(
        userDto: userDto,
        appearanceSettingsDto: appearanceSettingsDto,
        workoutSettingsDto: workoutSettingsDto,
      );
      addEntity(user);
      return user;
    }
    return null;
  }

  Future<AppearanceSettingsDto?> _updateAppearanceSettings(
    String userId,
    settings.ThemeMode? themeMode,
    settings.Language? language,
  ) async =>
      await _dbAppearanceSettingsService.updateSettings(
        userId: userId,
        themeMode: themeMode != null ? mapThemeModeToDb(themeMode) : null,
        language: language != null ? mapLanguageToDb(language) : null,
      );

  Future<WorkoutSettingsDto?> _updateWorkoutSettings(
    String userId,
    settings.DistanceUnit? distanceUnit,
    settings.PaceUnit? paceUnit,
  ) async =>
      await _dbWorkoutSettingsService.updateSettings(
        userId: userId,
        distanceUnit:
            distanceUnit != null ? mapDistanceUnitToDb(distanceUnit) : null,
        paceUnit: paceUnit != null ? mapPaceUnitToDb(paceUnit) : null,
      );
}
