import 'package:collection/collection.dart';
import 'package:firebase/firebase.dart' as firebase;

import '../../dependency_injection.dart';
import '../../domain/additional_model/state_repository.dart';
import '../../domain/entity/settings.dart' as settings;
import '../../domain/entity/settings.dart';
import '../../domain/entity/user.dart';
import '../../domain/repository/user_repository.dart';
import '../mapper/gender_mapper.dart';
import '../mapper/settings_mapper.dart';
import '../mapper/user_mapper.dart';

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
  Stream<User?> getUserById({required String userId}) async* {
    await for (final users in dataStream$) {
      User? user = users?.firstWhereOrNull(
        (User? user) => user?.id == userId,
      );
      user ??= await _loadUserFromDb(userId);
      yield user;
    }
  }

  @override
  Future<void> addUser({required User user}) async {
    final firebase.UserDto? userDto = await _dbUserService.addUserData(
      userDto: firebase.UserDto(
        id: user.id,
        gender: mapGenderToDto(user.gender),
        name: user.name,
        surname: user.surname,
        email: user.email,
        coachId: user.coachId,
        clientIds: user.clientIds,
      ),
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
    final Settings settings = mapSettingsFromDto(
      appearanceSettingsDto: appearanceSettingsDto,
      activitiesSettingsDto: activitiesSettingsDto,
    );
    final User addedUser = mapUserFromDto(userDto: userDto, settings: settings);
    addEntity(addedUser);
  }

  //TODO: Add email parameter
  @override
  Future<void> updateUser({
    required String userId,
    Gender? gender,
    String? name,
    String? surname,
    String? coachId,
    bool coachIdAsNull = false,
    List<String>? clientIds,
    bool clientIdsAsNull = false,
  }) async {
    final Stream<User?> user$ = getUserById(userId: userId);
    await for (final user in user$) {
      if (user == null) return;
      final updatedUserDto = await _dbUserService.updateUserData(
        userId: userId,
        gender: gender != null ? mapGenderToDto(gender) : null,
        name: name,
        surname: surname,
        coachId: coachId,
        coachIdAsNull: coachIdAsNull,
        clientIds: clientIds,
        clientIdsAsNull: clientIdsAsNull,
      );
      if (updatedUserDto == null) return;
      final User updatedUser = mapUserFromDto(
        userDto: updatedUserDto,
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
      final settings.Settings updatedSettings = settings.Settings(
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
      //TODO: Implement email
      final User updatedUser = User(
        id: user.id,
        accountType: user.accountType,
        gender: user.gender,
        name: user.name,
        surname: user.surname,
        email: '',
        settings: updatedSettings,
        coachId: user.coachId,
        clientIds: user.clientIds,
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
    await _dbActivitiesSettingsService.deleteSettingsForUser(userId: userId);
    await _dbUserService.deleteUserData(userId: userId);
    removeEntity(userId);
  }

  Future<User?> _loadUserFromDb(String userId) async {
    final userDto = await _dbUserService.loadUserById(userId: userId);
    if (userDto == null) return null;
    final firebase.AppearanceSettingsDto? appearanceSettingsDto =
        await _dbAppearanceSettingsService.loadSettingsByUserId(userId: userId);
    final firebase.ActivitiesSettingsDto? activitiesSettingsDto =
        await _dbActivitiesSettingsService.loadSettingsByUserId(userId: userId);
    if (appearanceSettingsDto != null && activitiesSettingsDto != null) {
      final User user = mapUserFromDto(
        userDto: userDto,
        settings: mapSettingsFromDto(
          appearanceSettingsDto: appearanceSettingsDto,
          activitiesSettingsDto: activitiesSettingsDto,
        ),
      );
      addEntity(user);
      return user;
    }
    return null;
  }

  Future<firebase.AppearanceSettingsDto?> _updateAppearanceSettings(
    String userId,
    settings.ThemeMode? themeMode,
    settings.Language? language,
  ) async =>
      await _dbAppearanceSettingsService.updateSettings(
        userId: userId,
        themeMode: themeMode != null ? mapThemeModeToDb(themeMode) : null,
        language: language != null ? mapLanguageToDb(language) : null,
      );

  Future<firebase.ActivitiesSettingsDto?> _updateActivitiesSettings(
    String userId,
    settings.DistanceUnit? distanceUnit,
    settings.PaceUnit? paceUnit,
  ) async =>
      await _dbActivitiesSettingsService.updateSettings(
        userId: userId,
        distanceUnit:
            distanceUnit != null ? mapDistanceUnitToDb(distanceUnit) : null,
        paceUnit: paceUnit != null ? mapPaceUnitToDb(paceUnit) : null,
      );
}
