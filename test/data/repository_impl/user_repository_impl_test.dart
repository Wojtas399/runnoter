import 'package:firebase/firebase.dart' as db;
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/repository_impl/user_repository_impl.dart';
import 'package:runnoter/domain/entity/settings.dart';
import 'package:runnoter/domain/entity/user.dart';

import '../../creators/settings_creator.dart';
import '../../creators/user_creator.dart';
import '../../mock/firebase/mock_firebase_activities_settings_service.dart';
import '../../mock/firebase/mock_firebase_appearance_settings_service.dart';
import '../../mock/firebase/mock_firebase_user_service.dart';

void main() {
  final dbUserService = MockFirebaseUserService();
  final dbAppearanceSettingsService = MockFirebaseAppearanceSettingsService();
  final dbActivitiesSettingsService = MockFirebaseActivitiesSettingsService();
  late UserRepositoryImpl repository;
  const String userId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<db.FirebaseUserService>(() => dbUserService);
    GetIt.I.registerFactory<db.FirebaseAppearanceSettingsService>(
      () => dbAppearanceSettingsService,
    );
    GetIt.I.registerFactory<db.FirebaseActivitiesSettingsService>(
      () => dbActivitiesSettingsService,
    );
  });

  setUp(() {
    repository = UserRepositoryImpl();
  });

  tearDown(() {
    reset(dbUserService);
    reset(dbAppearanceSettingsService);
    reset(dbActivitiesSettingsService);
  });

  test(
    'get user by id, '
    'user exists in state, '
    'should emit user from repository',
    () {
      final User expectedUser = createRunner(id: userId);
      repository = UserRepositoryImpl(initialState: [expectedUser]);

      final Stream<User?> user$ = repository.getUserById(userId: userId);

      expect(
        user$,
        emitsInOrder([expectedUser]),
      );
    },
  );

  test(
    'get user by id, '
    'user does not exist in state, '
    'should emit user loaded from remote db',
    () {
      const userDto = db.UserDto(
        id: userId,
        gender: db.Gender.male,
        name: 'name',
        surname: 'surname',
      );
      const appearanceSettingsDto = db.AppearanceSettingsDto(
        userId: userId,
        themeMode: db.ThemeMode.light,
        language: db.Language.polish,
      );
      const workoutSettingsDto = db.WorkoutSettingsDto(
        userId: userId,
        distanceUnit: db.DistanceUnit.kilometers,
        paceUnit: db.PaceUnit.minutesPerKilometer,
      );
      final User expectedUser = createRunner(
        id: userId,
        gender: Gender.male,
        name: 'name',
        surname: 'surname',
        settings: createSettings(
          themeMode: ThemeMode.light,
          language: Language.polish,
          distanceUnit: DistanceUnit.kilometers,
          paceUnit: PaceUnit.minutesPerKilometer,
        ),
      );
      dbUserService.mockLoadUserById(userDto: userDto);
      dbAppearanceSettingsService.mockLoadSettingsByUserId(
        appearanceSettingsDto: appearanceSettingsDto,
      );
      dbActivitiesSettingsService.mockLoadSettingsByUserId(
        workoutSettingsDto: workoutSettingsDto,
      );

      final Stream<User?> user$ = repository.getUserById(userId: userId);

      expect(
        user$,
        emitsInOrder([expectedUser]),
      );
    },
  );

  test(
    'add user, '
    'runner, '
    'should call db methods to add user personal data, appearance settings, workout settings and should add user to repository',
    () async {
      final User userToAdd = createRunner(
        id: userId,
        gender: Gender.male,
        name: 'username',
        surname: 'surname',
        settings: createSettings(
          themeMode: ThemeMode.light,
          language: Language.english,
        ),
        coachId: 'c1',
      );
      dbUserService.mockAddUserPersonalData();
      dbAppearanceSettingsService.mockAddSettings();
      dbActivitiesSettingsService.mockAddSettings();

      await repository.addUser(user: userToAdd);
      final Stream<User?> user$ = repository.getUserById(userId: userToAdd.id);

      expect(await user$.first, userToAdd);
      verify(
        () => dbUserService.addUserPersonalData(
          userDto: const db.UserDto(
            id: userId,
            gender: db.Gender.male,
            name: 'username',
            surname: 'surname',
            coachId: 'c1',
          ),
        ),
      ).called(1);
      verify(
        () => dbAppearanceSettingsService.addSettings(
          appearanceSettingsDto: const db.AppearanceSettingsDto(
            userId: userId,
            themeMode: db.ThemeMode.light,
            language: db.Language.english,
          ),
        ),
      ).called(1);
      verify(
        () => dbActivitiesSettingsService.addSettings(
          workoutSettingsDto: const db.WorkoutSettingsDto(
            userId: userId,
            distanceUnit: db.DistanceUnit.kilometers,
            paceUnit: db.PaceUnit.minutesPerKilometer,
          ),
        ),
      ).called(1);
    },
  );

  test(
    'add user, '
    'coach, '
    'should call db methods to add user personal data, appearance settings, workout settings and should add user to repository',
    () async {
      final User userToAdd = createCoach(
        id: userId,
        gender: Gender.male,
        name: 'username',
        surname: 'surname',
        settings: createSettings(
          themeMode: ThemeMode.light,
          language: Language.english,
        ),
        coachId: 'c1',
        clientIds: ['r1', 'r2'],
      );
      dbUserService.mockAddUserPersonalData();
      dbAppearanceSettingsService.mockAddSettings();
      dbActivitiesSettingsService.mockAddSettings();

      await repository.addUser(user: userToAdd);
      final Stream<User?> user$ = repository.getUserById(userId: userToAdd.id);

      expect(await user$.first, userToAdd);
      verify(
        () => dbUserService.addUserPersonalData(
          userDto: const db.UserDto(
            id: userId,
            gender: db.Gender.male,
            name: 'username',
            surname: 'surname',
            coachId: 'c1',
            clientIds: ['r1', 'r2'],
          ),
        ),
      ).called(1);
      verify(
        () => dbAppearanceSettingsService.addSettings(
          appearanceSettingsDto: const db.AppearanceSettingsDto(
            userId: userId,
            themeMode: db.ThemeMode.light,
            language: db.Language.english,
          ),
        ),
      ).called(1);
      verify(
        () => dbActivitiesSettingsService.addSettings(
          workoutSettingsDto: const db.WorkoutSettingsDto(
            userId: userId,
            distanceUnit: db.DistanceUnit.kilometers,
            paceUnit: db.PaceUnit.minutesPerKilometer,
          ),
        ),
      ).called(1);
    },
  );

  test(
    'update user, '
    'user does not exist in repository, '
    'should do nothing',
    () async {
      final List<User> existingUsers = [
        createRunner(id: 'u2'),
        createRunner(id: 'u3'),
      ];
      const String newName = 'name';
      const String newSurname = 'surname';
      repository = UserRepositoryImpl(initialState: existingUsers);
      dbUserService.mockLoadUserById();

      await repository.updateUser(
        userId: userId,
        name: newName,
        surname: newSurname,
      );
      final Stream<User?> user$ = repository.getUserById(userId: userId);

      expect(await user$.first, null);
      verifyNever(
        () => dbUserService.updateUserData(
          userId: userId,
          name: any(named: 'name'),
          surname: any(named: 'surname'),
        ),
      );
    },
  );

  test(
    'update user, '
    'user exists in repository, '
    'db method does not return updated user dto, '
    'should not update user in repository',
    () async {
      const String newName = 'name';
      const String newSurname = 'surname';
      final Settings userSettings = createSettings(
        themeMode: ThemeMode.dark,
        language: Language.english,
        distanceUnit: DistanceUnit.miles,
        paceUnit: PaceUnit.milesPerHour,
      );
      final User existingUser = createRunner(
        id: userId,
        name: 'username',
        surname: 'surname1',
        settings: userSettings,
      );
      repository = UserRepositoryImpl(initialState: [existingUser]);
      dbUserService.mockUpdateUserData();

      await repository.updateUser(
        userId: userId,
        name: newName,
        surname: newSurname,
      );
      final Stream<User?> user$ = repository.getUserById(userId: userId);

      expect(await user$.first, existingUser);
      verify(
        () => dbUserService.updateUserData(
          userId: userId,
          name: newName,
          surname: newSurname,
        ),
      ).called(1);
    },
  );

  test(
    'update user, '
    'runner, '
    "should call db method to update user's data and should update user in repository",
    () async {
      const String newName = 'name';
      const String newSurname = 'surname';
      const String newCoachId = 'c2';
      final Settings userSettings = createSettings(
        themeMode: ThemeMode.dark,
        language: Language.english,
        distanceUnit: DistanceUnit.miles,
        paceUnit: PaceUnit.milesPerHour,
      );
      final User existingUser = createRunner(
        id: userId,
        name: 'username',
        surname: 'surname1',
        settings: userSettings,
        coachId: 'c1',
      );
      const updatedUserDto = db.UserDto(
        id: userId,
        gender: db.Gender.male,
        name: newName,
        surname: newSurname,
        coachId: newCoachId,
      );
      final User expectedUpdatedUser = createRunner(
        id: userId,
        gender: Gender.male,
        name: newName,
        surname: newSurname,
        settings: userSettings,
        coachId: newCoachId,
      );
      repository = UserRepositoryImpl(initialState: [existingUser]);
      dbUserService.mockUpdateUserData(userDto: updatedUserDto);

      await repository.updateUser(
        userId: userId,
        name: newName,
        surname: newSurname,
        coachId: newCoachId,
      );
      final Stream<User?> user$ = repository.getUserById(userId: userId);

      expect(await user$.first, expectedUpdatedUser);
      verify(
        () => dbUserService.updateUserData(
          userId: userId,
          name: newName,
          surname: newSurname,
          coachId: newCoachId,
        ),
      ).called(1);
    },
  );

  test(
    'update user, '
    'coach, '
    "should call db method to update user's data and should update user in repository",
    () async {
      const String newName = 'name';
      const String newSurname = 'surname';
      const String newCoachId = 'c2';
      const List<String> newClientIds = ['r1', 'r2'];
      final Settings userSettings = createSettings(
        themeMode: ThemeMode.dark,
        language: Language.english,
        distanceUnit: DistanceUnit.miles,
        paceUnit: PaceUnit.milesPerHour,
      );
      final User existingUser = createCoach(
        id: userId,
        name: 'username',
        surname: 'surname1',
        settings: userSettings,
        coachId: 'c1',
        clientIds: ['r1'],
      );
      const updatedUserDto = db.UserDto(
        id: userId,
        gender: db.Gender.male,
        name: newName,
        surname: newSurname,
        coachId: newCoachId,
        clientIds: newClientIds,
      );
      final User expectedUpdatedUser = createCoach(
        id: userId,
        gender: Gender.male,
        name: newName,
        surname: newSurname,
        settings: userSettings,
        coachId: newCoachId,
        clientIds: newClientIds,
      );
      repository = UserRepositoryImpl(initialState: [existingUser]);
      dbUserService.mockUpdateUserData(userDto: updatedUserDto);

      await repository.updateUser(
        userId: userId,
        name: newName,
        surname: newSurname,
        coachId: newCoachId,
        clientIds: newClientIds,
      );
      final Stream<User?> user$ = repository.getUserById(userId: userId);

      expect(await user$.first, expectedUpdatedUser);
      verify(
        () => dbUserService.updateUserData(
          userId: userId,
          name: newName,
          surname: newSurname,
          coachId: newCoachId,
          clientIds: newClientIds,
        ),
      ).called(1);
    },
  );

  test(
    'update user, '
    'runner to coach, '
    "should call db method to update user's data and should update user in repository",
    () async {
      const String newName = 'name';
      const String newSurname = 'surname';
      const String newCoachId = 'c2';
      const List<String> clientIds = ['r1', 'r2'];
      final Settings userSettings = createSettings(
        themeMode: ThemeMode.dark,
        language: Language.english,
        distanceUnit: DistanceUnit.miles,
        paceUnit: PaceUnit.milesPerHour,
      );
      final User existingUser = createRunner(
        id: userId,
        name: 'username',
        surname: 'surname1',
        settings: userSettings,
        coachId: 'c1',
      );
      const updatedUserDto = db.UserDto(
        id: userId,
        gender: db.Gender.male,
        name: newName,
        surname: newSurname,
        coachId: newCoachId,
        clientIds: clientIds,
      );
      final User expectedUpdatedUser = createCoach(
        id: userId,
        gender: Gender.male,
        name: newName,
        surname: newSurname,
        settings: userSettings,
        coachId: newCoachId,
        clientIds: clientIds,
      );
      repository = UserRepositoryImpl(initialState: [existingUser]);
      dbUserService.mockUpdateUserData(userDto: updatedUserDto);

      await repository.updateUser(
        userId: userId,
        name: newName,
        surname: newSurname,
        coachId: newCoachId,
        clientIds: clientIds,
      );
      final Stream<User?> user$ = repository.getUserById(userId: userId);

      expect(await user$.first, expectedUpdatedUser);
      verify(
        () => dbUserService.updateUserData(
          userId: userId,
          name: newName,
          surname: newSurname,
          coachId: newCoachId,
          clientIds: clientIds,
        ),
      ).called(1);
    },
  );

  test(
    'update user, '
    'coach to runner, '
    "should call db method to update user's data and should update user in repository",
    () async {
      const String newName = 'name';
      const String newSurname = 'surname';
      const String newCoachId = 'c2';
      final Settings userSettings = createSettings(
        themeMode: ThemeMode.dark,
        language: Language.english,
        distanceUnit: DistanceUnit.miles,
        paceUnit: PaceUnit.milesPerHour,
      );
      final User existingUser = createCoach(
        id: userId,
        name: 'username',
        surname: 'surname1',
        settings: userSettings,
        coachId: 'c1',
        clientIds: ['r1'],
      );
      const updatedUserDto = db.UserDto(
        id: userId,
        gender: db.Gender.male,
        name: newName,
        surname: newSurname,
        coachId: newCoachId,
      );
      final User expectedUpdatedUser = createRunner(
        id: userId,
        gender: Gender.male,
        name: newName,
        surname: newSurname,
        settings: userSettings,
        coachId: newCoachId,
      );
      repository = UserRepositoryImpl(initialState: [existingUser]);
      dbUserService.mockUpdateUserData(userDto: updatedUserDto);

      await repository.updateUser(
        userId: userId,
        name: newName,
        surname: newSurname,
        coachId: newCoachId,
        clientIdsAsNull: true,
      );
      final Stream<User?> user$ = repository.getUserById(userId: userId);

      expect(await user$.first, expectedUpdatedUser);
      verify(
        () => dbUserService.updateUserData(
          userId: userId,
          name: newName,
          surname: newSurname,
          coachId: newCoachId,
          clientIdsAsNull: true,
        ),
      ).called(1);
    },
  );

  test(
    'update user settings, '
    'user does not exist in repository, '
    'should do nothing',
    () async {
      final List<User> existingUsers = [
        createRunner(id: 'u2'),
        createRunner(id: 'u3'),
      ];
      const ThemeMode newThemeMode = ThemeMode.dark;
      const Language newLanguage = Language.english;
      const DistanceUnit newDistanceUnit = DistanceUnit.miles;
      const PaceUnit newPaceUnit = PaceUnit.minutesPerMile;
      repository = UserRepositoryImpl(
        initialState: existingUsers,
      );
      dbUserService.mockLoadUserById();

      await repository.updateUserSettings(
        userId: userId,
        themeMode: newThemeMode,
        language: newLanguage,
        distanceUnit: newDistanceUnit,
        paceUnit: newPaceUnit,
      );
      final Stream<User?> user$ = repository.getUserById(userId: userId);

      expect(await user$.first, null);
      verifyNever(
        () => dbAppearanceSettingsService.updateSettings(
          userId: userId,
          themeMode: any(named: 'themeMode'),
          language: any(named: 'language'),
        ),
      );
      verifyNever(
        () => dbActivitiesSettingsService.updateSettings(
          userId: userId,
          distanceUnit: any(named: 'distanceUnit'),
          paceUnit: any(named: 'paceUnit'),
        ),
      );
    },
  );

  test(
    'update user settings, '
    'user exists in state, '
    'db methods do not return updated appearance and workout settings, '
    'should not update user in repository',
    () async {
      final User existingUser = createRunner(id: userId);
      const ThemeMode newThemeMode = ThemeMode.dark;
      const Language newLanguage = Language.english;
      const DistanceUnit newDistanceUnit = DistanceUnit.miles;
      const PaceUnit newPaceUnit = PaceUnit.minutesPerMile;
      const db.ThemeMode newDbThemeMode = db.ThemeMode.dark;
      const db.Language newDbLanguage = db.Language.english;
      const db.DistanceUnit newDbDistanceUnit = db.DistanceUnit.miles;
      const db.PaceUnit newDbPaceUnit = db.PaceUnit.minutesPerMile;
      dbAppearanceSettingsService.mockUpdateSettings();
      dbActivitiesSettingsService.mockUpdateSettings();
      repository = UserRepositoryImpl(
        initialState: [existingUser],
      );

      await repository.updateUserSettings(
        userId: userId,
        themeMode: newThemeMode,
        language: newLanguage,
        distanceUnit: newDistanceUnit,
        paceUnit: newPaceUnit,
      );
      final Stream<User?> user$ = repository.getUserById(userId: userId);

      expect(await user$.first, existingUser);
      verify(
        () => dbAppearanceSettingsService.updateSettings(
          userId: userId,
          themeMode: newDbThemeMode,
          language: newDbLanguage,
        ),
      ).called(1);
      verify(
        () => dbActivitiesSettingsService.updateSettings(
          userId: userId,
          distanceUnit: newDbDistanceUnit,
          paceUnit: newDbPaceUnit,
        ),
      ).called(1);
    },
  );

  test(
    'update user settings, '
    'runner, '
    'should call db method to update appearance and workout settings and should update user in repository',
    () async {
      final User existingUser = createRunner(
        id: userId,
        gender: Gender.male,
        name: 'name',
        surname: 'surname',
        coachId: 'c1',
      );
      const ThemeMode newThemeMode = ThemeMode.dark;
      const Language newLanguage = Language.english;
      const DistanceUnit newDistanceUnit = DistanceUnit.miles;
      const PaceUnit newPaceUnit = PaceUnit.minutesPerMile;
      const db.ThemeMode newDbThemeMode = db.ThemeMode.dark;
      const db.Language newDbLanguage = db.Language.english;
      const db.DistanceUnit newDbDistanceUnit = db.DistanceUnit.miles;
      const db.PaceUnit newDbPaceUnit = db.PaceUnit.minutesPerMile;
      final User expectedUpdatedUser = createRunner(
        id: userId,
        gender: existingUser.gender,
        name: existingUser.name,
        surname: existingUser.surname,
        coachId: existingUser.coachId,
        settings: createSettings(
          themeMode: newThemeMode,
          language: newLanguage,
          distanceUnit: newDistanceUnit,
          paceUnit: newPaceUnit,
        ),
      );
      const updatedAppearanceSettingsDto = db.AppearanceSettingsDto(
        userId: userId,
        themeMode: newDbThemeMode,
        language: newDbLanguage,
      );
      const updatedWorkoutSettingsDto = db.WorkoutSettingsDto(
        userId: userId,
        distanceUnit: newDbDistanceUnit,
        paceUnit: newDbPaceUnit,
      );
      dbAppearanceSettingsService.mockUpdateSettings(
        updatedAppearanceSettingsDto: updatedAppearanceSettingsDto,
      );
      dbActivitiesSettingsService.mockUpdateSettings(
        updatedWorkoutSettingsDto: updatedWorkoutSettingsDto,
      );
      repository = UserRepositoryImpl(initialState: [existingUser]);

      await repository.updateUserSettings(
        userId: userId,
        themeMode: newThemeMode,
        language: newLanguage,
        distanceUnit: newDistanceUnit,
        paceUnit: newPaceUnit,
      );
      final Stream<User?> user$ = repository.getUserById(userId: userId);

      expect(await user$.first, expectedUpdatedUser);
      verify(
        () => dbAppearanceSettingsService.updateSettings(
          userId: userId,
          themeMode: newDbThemeMode,
          language: newDbLanguage,
        ),
      ).called(1);
      verify(
        () => dbActivitiesSettingsService.updateSettings(
          userId: userId,
          distanceUnit: newDbDistanceUnit,
          paceUnit: newDbPaceUnit,
        ),
      ).called(1);
    },
  );

  test(
    'update user settings, '
    'coach, '
    'should call db method to update appearance and workout settings and should update user in repository',
    () async {
      final Coach existingUser = createCoach(
        id: userId,
        gender: Gender.male,
        name: 'name',
        surname: 'surname',
        coachId: 'c1',
        clientIds: ['r1'],
      );
      const ThemeMode newThemeMode = ThemeMode.dark;
      const Language newLanguage = Language.english;
      const DistanceUnit newDistanceUnit = DistanceUnit.miles;
      const PaceUnit newPaceUnit = PaceUnit.minutesPerMile;
      const db.ThemeMode newDbThemeMode = db.ThemeMode.dark;
      const db.Language newDbLanguage = db.Language.english;
      const db.DistanceUnit newDbDistanceUnit = db.DistanceUnit.miles;
      const db.PaceUnit newDbPaceUnit = db.PaceUnit.minutesPerMile;
      final User expectedUpdatedUser = createCoach(
        id: userId,
        gender: existingUser.gender,
        name: existingUser.name,
        surname: existingUser.surname,
        coachId: existingUser.coachId,
        clientIds: existingUser.clientIds,
        settings: createSettings(
          themeMode: newThemeMode,
          language: newLanguage,
          distanceUnit: newDistanceUnit,
          paceUnit: newPaceUnit,
        ),
      );
      const updatedAppearanceSettingsDto = db.AppearanceSettingsDto(
        userId: userId,
        themeMode: newDbThemeMode,
        language: newDbLanguage,
      );
      const updatedWorkoutSettingsDto = db.WorkoutSettingsDto(
        userId: userId,
        distanceUnit: newDbDistanceUnit,
        paceUnit: newDbPaceUnit,
      );
      dbAppearanceSettingsService.mockUpdateSettings(
        updatedAppearanceSettingsDto: updatedAppearanceSettingsDto,
      );
      dbActivitiesSettingsService.mockUpdateSettings(
        updatedWorkoutSettingsDto: updatedWorkoutSettingsDto,
      );
      repository = UserRepositoryImpl(initialState: [existingUser]);

      await repository.updateUserSettings(
        userId: userId,
        themeMode: newThemeMode,
        language: newLanguage,
        distanceUnit: newDistanceUnit,
        paceUnit: newPaceUnit,
      );
      final Stream<User?> user$ = repository.getUserById(userId: userId);

      expect(await user$.first, expectedUpdatedUser);
      verify(
        () => dbAppearanceSettingsService.updateSettings(
          userId: userId,
          themeMode: newDbThemeMode,
          language: newDbLanguage,
        ),
      ).called(1);
      verify(
        () => dbActivitiesSettingsService.updateSettings(
          userId: userId,
          distanceUnit: newDbDistanceUnit,
          paceUnit: newDbPaceUnit,
        ),
      ).called(1);
    },
  );

  test(
    'delete user, '
    'should call db methods to delete user data, appearance settings and workout settings and then should delete user from repository',
    () async {
      final User user = createRunner(id: userId);
      dbUserService.mockLoadUserById();
      dbUserService.mockDeleteUserData();
      dbAppearanceSettingsService.mockDeleteSettingsForUser();
      dbActivitiesSettingsService.mockDeleteSettingsForUser();
      repository = UserRepositoryImpl(
        initialState: [user],
      );

      final Stream<User?> user$ = repository.getUserById(userId: user.id);
      await repository.deleteUser(userId: user.id);

      expect(
        user$,
        emitsInOrder([null]),
      );
      verify(
        () => dbUserService.deleteUserData(userId: user.id),
      ).called(1);
      verify(
        () => dbAppearanceSettingsService.deleteSettingsForUser(
          userId: user.id,
        ),
      ).called(1);
      verify(
        () => dbActivitiesSettingsService.deleteSettingsForUser(
          userId: user.id,
        ),
      ).called(1);
    },
  );
}
