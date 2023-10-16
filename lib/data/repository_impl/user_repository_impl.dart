import 'package:collection/collection.dart';
import 'package:firebase/firebase.dart' as firebase;

import '../../dependency_injection.dart';
import '../entity/user.dart';
import '../interface/repository/user_repository.dart';
import '../mapper/account_type_mapper.dart';
import '../mapper/gender_mapper.dart';
import '../mapper/user_mapper.dart';
import '../mapper/user_settings_mapper.dart';
import '../model/state_repository.dart';

class UserRepositoryImpl extends StateRepository<User>
    implements UserRepository {
  final firebase.FirebaseUserService _dbUserService;
  final firebase.FirebaseAppearanceSettingsService _dbAppearanceSettingsService;
  final firebase.FirebaseActivitiesSettingsService _dbActivitiesSettingsService;

  UserRepositoryImpl({
    List<User>? initialState,
  })  : _dbUserService = getIt<firebase.FirebaseUserService>(),
        _dbAppearanceSettingsService =
            getIt<firebase.FirebaseAppearanceSettingsService>(),
        _dbActivitiesSettingsService =
            getIt<firebase.FirebaseActivitiesSettingsService>(),
        super(initialData: initialState);

  @override
  Stream<User?> getUserById({required String userId}) => dataStream$
      .map(
        (List<User>? users) => users?.firstWhereOrNull(
          (User? user) => user?.id == userId,
        ),
      )
      .asyncMap((User? user) async => user ?? await _loadUserFromDb(userId));

  @override
  Future<void> addUser({required User user}) async {
    final firebase.UserDto? userDto = await _dbUserService.addUserData(
      userDto: mapUserToDto(user: user),
    );
    final appearanceSettingsDto =
        await _dbAppearanceSettingsService.addSettings(
      appearanceSettingsDto: firebase.AppearanceSettingsDto(
        userId: user.id,
        themeMode: mapThemeModeToDb(user.settings.themeMode),
        language: mapLanguageToDb(user.settings.language),
      ),
    );
    final activitiesSettingsDto =
        await _dbActivitiesSettingsService.addSettings(
      activitiesSettingsDto: firebase.ActivitiesSettingsDto(
        userId: user.id,
        distanceUnit: mapDistanceUnitToDb(user.settings.distanceUnit),
        paceUnit: mapPaceUnitToDb(user.settings.paceUnit),
      ),
    );
    if (userDto == null ||
        appearanceSettingsDto == null ||
        activitiesSettingsDto == null) return;
    final UserSettings userSettings = mapSettingsFromDto(
      appearanceSettingsDto: appearanceSettingsDto,
      activitiesSettingsDto: activitiesSettingsDto,
    );
    final User addedUser = mapUserFromDto(
      userDto: userDto,
      userSettings: userSettings,
    );
    addEntity(addedUser);
  }

  @override
  Future<void> updateUser({
    required String userId,
    AccountType? accountType,
    Gender? gender,
    String? name,
    String? surname,
    String? email,
    DateTime? dateOfBirth,
    String? coachId,
    bool coachIdAsNull = false,
  }) async {
    final Stream<User?> user$ = getUserById(userId: userId);
    await for (final user in user$) {
      if (user == null) return;
      final updatedUserDto = await _dbUserService.updateUserData(
        userId: userId,
        accountType:
            accountType != null ? mapAccountTypeToDto(accountType) : null,
        gender: gender != null ? mapGenderToDto(gender) : null,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
        coachId: coachId,
        coachIdAsNull: coachIdAsNull,
      );
      if (updatedUserDto == null) return;
      final User updatedUser = mapUserFromDto(
        userDto: updatedUserDto,
        userSettings: user.settings,
      );
      updateEntity(updatedUser);
      return;
    }
  }

  @override
  Future<void> updateUserSettings({
    required String userId,
    ThemeMode? themeMode,
    Language? language,
    DistanceUnit? distanceUnit,
    PaceUnit? paceUnit,
  }) async {
    final Stream<User?> user$ = getUserById(userId: userId);
    await for (final user in user$) {
      if (user == null) return;
      firebase.AppearanceSettingsDto? newAppearanceSettingsDto;
      firebase.ActivitiesSettingsDto? newActivitiesSettingsDto;
      if (themeMode != null || language != null) {
        newAppearanceSettingsDto =
            await _updateAppearanceSettings(userId, themeMode, language);
      }
      if (distanceUnit != null || paceUnit != null) {
        newActivitiesSettingsDto =
            await _updateActivitiesSettings(userId, distanceUnit, paceUnit);
      }
      if (newAppearanceSettingsDto == null &&
          newActivitiesSettingsDto == null) {
        return;
      }
      final UserSettings updatedSettings = UserSettings(
        themeMode: newAppearanceSettingsDto != null
            ? mapThemeModeFromDb(newAppearanceSettingsDto.themeMode)
            : user.settings.themeMode,
        language: newAppearanceSettingsDto != null
            ? mapLanguageFromDb(newAppearanceSettingsDto.language)
            : user.settings.language,
        distanceUnit: newActivitiesSettingsDto != null
            ? mapDistanceUnitFromDb(newActivitiesSettingsDto.distanceUnit)
            : user.settings.distanceUnit,
        paceUnit: newActivitiesSettingsDto != null
            ? mapPaceUnitFromDb(newActivitiesSettingsDto.paceUnit)
            : user.settings.paceUnit,
      );
      final User updatedUser = User(
        id: user.id,
        accountType: user.accountType,
        gender: user.gender,
        name: user.name,
        surname: user.surname,
        email: user.email,
        dateOfBirth: user.dateOfBirth,
        settings: updatedSettings,
        coachId: user.coachId,
      );
      updateEntity(updatedUser);
      return;
    }
  }

  @override
  Future<void> refreshUserById({required String userId}) async {
    await _loadUserFromDb(userId);
  }

  @override
  Future<void> deleteUser({
    required String userId,
  }) async {
    await _dbAppearanceSettingsService.deleteSettingsForUser(userId: userId);
    await _dbActivitiesSettingsService.deleteSettingsForUser(userId: userId);
    await _dbUserService.deleteUserData(userId: userId);
    removeEntity(userId);
  }

  Future<User?> _loadUserFromDb(String userId) async {
    final userDto = await _dbUserService.loadUserById(userId: userId);
    if (userDto == null) return null;
    final UserSettings userSettings = await _loadUserSettingsFromDb(userId);
    final User user = mapUserFromDto(
      userDto: userDto,
      userSettings: userSettings,
    );
    addEntity(user);
    return user;
  }

  Future<UserSettings> _loadUserSettingsFromDb(String userId) async {
    final firebase.AppearanceSettingsDto? appearanceSettingsDto =
        await _dbAppearanceSettingsService.loadSettingsByUserId(userId: userId);
    final firebase.ActivitiesSettingsDto? activitiesSettingsDto =
        await _dbActivitiesSettingsService.loadSettingsByUserId(userId: userId);
    if (appearanceSettingsDto == null || activitiesSettingsDto == null) {
      throw '[UserRepository] Cannot load user settings';
    }
    return mapSettingsFromDto(
      appearanceSettingsDto: appearanceSettingsDto,
      activitiesSettingsDto: activitiesSettingsDto,
    );
  }

  Future<firebase.AppearanceSettingsDto?> _updateAppearanceSettings(
    String userId,
    ThemeMode? themeMode,
    Language? language,
  ) async =>
      await _dbAppearanceSettingsService.updateSettings(
        userId: userId,
        themeMode: themeMode != null ? mapThemeModeToDb(themeMode) : null,
        language: language != null ? mapLanguageToDb(language) : null,
      );

  Future<firebase.ActivitiesSettingsDto?> _updateActivitiesSettings(
    String userId,
    DistanceUnit? distanceUnit,
    PaceUnit? paceUnit,
  ) async =>
      await _dbActivitiesSettingsService.updateSettings(
        userId: userId,
        distanceUnit:
            distanceUnit != null ? mapDistanceUnitToDb(distanceUnit) : null,
        paceUnit: paceUnit != null ? mapPaceUnitToDb(paceUnit) : null,
      );
}
