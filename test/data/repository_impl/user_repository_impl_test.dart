import 'package:firebase/firebase.dart' as db;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/repository_impl/user_repository_impl.dart';
import 'package:runnoter/domain/model/settings.dart';
import 'package:runnoter/domain/model/user.dart';

import '../../mock/firebase/mock_firebase_appearance_settings_service.dart';
import '../../mock/firebase/mock_firebase_user_service.dart';
import '../../mock/firebase/mock_firebase_workout_settings_service.dart';
import '../../util/settings_creator.dart';
import '../../util/user_creator.dart';

void main() {
  final dbUserService = MockFirebaseUserService();
  final dbAppearanceSettingsService = MockFirebaseAppearanceSettingsService();
  final dbWorkoutSettingsService = MockFirebaseWorkoutSettingsService();
  late UserRepositoryImpl repository;
  const String userId = 'u1';

  UserRepositoryImpl createRepository({
    List<User>? initialState,
  }) {
    return UserRepositoryImpl(
      firebaseUserService: dbUserService,
      firebaseAppearanceSettingsService: dbAppearanceSettingsService,
      firebaseWorkoutSettingsService: dbWorkoutSettingsService,
      initialState: initialState,
    );
  }

  setUp(() {
    repository = createRepository();
  });

  tearDown(() {
    reset(dbUserService);
    reset(dbAppearanceSettingsService);
    reset(dbWorkoutSettingsService);
  });

  test(
    'get user by id, '
    'user exists in state, '
    'should emit user from repository and should not call db method to load user',
    () {
      final User expectedUser = createUser(id: userId);
      repository = createRepository(
        initialState: [expectedUser],
      );

      final Stream<User?> user$ = repository.getUserById(
        userId: userId,
      );
      user$.listen((_) {});

      expect(
        user$,
        emitsInOrder(
          [expectedUser],
        ),
      );
      verifyNever(
        () => dbUserService.loadUserById(
          userId: userId,
        ),
      );
      verifyNever(
        () => dbAppearanceSettingsService.loadSettingsByUserId(
          userId: userId,
        ),
      );
      verifyNever(
        () => dbWorkoutSettingsService.loadSettingsByUserId(
          userId: userId,
        ),
      );
    },
  );

  test(
    'get user by id, '
    'user does not exist in state, '
    'should call db method to load user, should add loaded user to repository and should emit loaded user',
    () {
      const userDto = db.UserDto(
        id: userId,
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
      final User expectedUser = createUser(
        id: userId,
        name: 'name',
        surname: 'surname',
        settings: createSettings(
          themeMode: ThemeMode.light,
          language: Language.polish,
          distanceUnit: DistanceUnit.kilometers,
          paceUnit: PaceUnit.minutesPerKilometer,
        ),
      );
      dbUserService.mockLoadUserById(
        userDto: userDto,
      );
      dbAppearanceSettingsService.mockLoadSettingsByUserId(
        appearanceSettingsDto: appearanceSettingsDto,
      );
      dbWorkoutSettingsService.mockLoadSettingsByUserId(
        workoutSettingsDto: workoutSettingsDto,
      );

      final Stream<User?> user$ = repository.getUserById(userId: userId);
      user$.listen((event) {});

      expectLater(
        user$,
        emitsInOrder(
          [null, expectedUser],
        ),
      ).then((_) {
        verify(
          () => dbUserService.loadUserById(
            userId: userId,
          ),
        ).called(1);
        verify(
          () => dbAppearanceSettingsService.loadSettingsByUserId(
            userId: userId,
          ),
        ).called(1);
        verify(
          () => dbWorkoutSettingsService.loadSettingsByUserId(
            userId: userId,
          ),
        ).called(1);
      });
    },
  );

  test(
    'add user identities, '
    'should call db methods to add user personal data, appearance settings, workout settings and should add user to repository',
    () async {
      final User userToAdd = createUser(
        id: userId,
        name: 'username',
        surname: 'surname',
        settings: createSettings(
          themeMode: ThemeMode.light,
          language: Language.english,
        ),
      );
      dbUserService.mockAddUserPersonalData();
      dbAppearanceSettingsService.mockAddSettings();
      dbWorkoutSettingsService.mockAddSettings();

      await repository.addUser(user: userToAdd);
      final Stream<User?> user$ = repository.getUserById(
        userId: userToAdd.id,
      );

      expect(await user$.first, userToAdd);
      verify(
        () => dbUserService.addUserPersonalData(
          userDto: const db.UserDto(
            id: userId,
            name: 'username',
            surname: 'surname',
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
        () => dbWorkoutSettingsService.addSettings(
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
    'update user identities, '
    'user does not exist in repository, '
    'should do nothing',
    () async {
      final List<User> existingUsers = [
        createUser(id: 'u2'),
        createUser(id: 'u3'),
      ];
      const String newName = 'name';
      const String newSurname = 'surname';
      repository = createRepository(
        initialState: existingUsers,
      );
      dbUserService.mockLoadUserById();

      await repository.updateUserIdentities(
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
    'update user identities, '
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
      final User existingUser = createUser(
        id: userId,
        name: 'username',
        surname: 'surname1',
        settings: userSettings,
      );
      repository = createRepository(
        initialState: [existingUser],
      );
      dbUserService.mockUpdateUserData();

      await repository.updateUserIdentities(
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
    'update user identities, '
    'user exists in repository, '
    "should call db method to update user's identities and should update user in repository",
    () async {
      const String newName = 'name';
      const String newSurname = 'surname';
      final Settings userSettings = createSettings(
        themeMode: ThemeMode.dark,
        language: Language.english,
        distanceUnit: DistanceUnit.miles,
        paceUnit: PaceUnit.milesPerHour,
      );
      final User existingUser = createUser(
        id: userId,
        name: 'username',
        surname: 'surname1',
        settings: userSettings,
      );
      const updatedUserDto = db.UserDto(
        id: userId,
        name: newName,
        surname: newSurname,
      );
      final User expectedUpdatedUser = createUser(
        id: userId,
        name: newName,
        surname: newSurname,
        settings: userSettings,
      );
      repository = createRepository(
        initialState: [existingUser],
      );
      dbUserService.mockUpdateUserData(userDto: updatedUserDto);

      await repository.updateUserIdentities(
        userId: userId,
        name: newName,
        surname: newSurname,
      );
      final Stream<User?> user$ = repository.getUserById(userId: userId);

      expect(await user$.first, expectedUpdatedUser);
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
    'update user settings, '
    'user does not exist in repository, '
    'should do nothing',
    () async {
      final List<User> existingUsers = [
        createUser(id: 'u2'),
        createUser(id: 'u3'),
      ];
      const ThemeMode newThemeMode = ThemeMode.dark;
      const Language newLanguage = Language.english;
      const DistanceUnit newDistanceUnit = DistanceUnit.miles;
      const PaceUnit newPaceUnit = PaceUnit.minutesPerMile;
      repository = createRepository(
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
        () => dbWorkoutSettingsService.updateSettings(
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
      final User existingUser = createUser(id: userId);
      const ThemeMode newThemeMode = ThemeMode.dark;
      const Language newLanguage = Language.english;
      const DistanceUnit newDistanceUnit = DistanceUnit.miles;
      const PaceUnit newPaceUnit = PaceUnit.minutesPerMile;
      const db.ThemeMode newDbThemeMode = db.ThemeMode.dark;
      const db.Language newDbLanguage = db.Language.english;
      const db.DistanceUnit newDbDistanceUnit = db.DistanceUnit.miles;
      const db.PaceUnit newDbPaceUnit = db.PaceUnit.minutesPerMile;
      dbAppearanceSettingsService.mockUpdateSettings();
      dbWorkoutSettingsService.mockUpdateSettings();
      repository = createRepository(
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
        () => dbWorkoutSettingsService.updateSettings(
          userId: userId,
          distanceUnit: newDbDistanceUnit,
          paceUnit: newDbPaceUnit,
        ),
      ).called(1);
    },
  );

  test(
    'update user settings, '
    'user exists in state, '
    'should call db method to update appearance and workout settings and should update user in repository',
    () async {
      final User existingUser = createUser(id: userId);
      const ThemeMode newThemeMode = ThemeMode.dark;
      const Language newLanguage = Language.english;
      const DistanceUnit newDistanceUnit = DistanceUnit.miles;
      const PaceUnit newPaceUnit = PaceUnit.minutesPerMile;
      const db.ThemeMode newDbThemeMode = db.ThemeMode.dark;
      const db.Language newDbLanguage = db.Language.english;
      const db.DistanceUnit newDbDistanceUnit = db.DistanceUnit.miles;
      const db.PaceUnit newDbPaceUnit = db.PaceUnit.minutesPerMile;
      final User expectedUpdatedUser = createUser(
        id: userId,
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
      dbWorkoutSettingsService.mockUpdateSettings(
        updatedWorkoutSettingsDto: updatedWorkoutSettingsDto,
      );
      repository = createRepository(
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

      expect(await user$.first, expectedUpdatedUser);
      verify(
        () => dbAppearanceSettingsService.updateSettings(
          userId: userId,
          themeMode: newDbThemeMode,
          language: newDbLanguage,
        ),
      ).called(1);
      verify(
        () => dbWorkoutSettingsService.updateSettings(
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
    () {
      final User user = createUser(id: userId);
      dbUserService.mockDeleteUserData();
      dbAppearanceSettingsService.mockDeleteSettingsForUser();
      dbWorkoutSettingsService.mockDeleteSettingsForUser();
      repository = createRepository(
        initialState: [user],
      );

      final Stream<User?> user$ = repository.getUserById(userId: user.id);
      repository.deleteUser(userId: user.id);

      expectLater(
        user$,
        emitsInOrder(
          [user, null],
        ),
      ).then(
        (_) {
          verify(
            () => dbUserService.deleteUserData(
              userId: user.id,
            ),
          ).called(1);
          verify(
            () => dbAppearanceSettingsService.deleteSettingsForUser(
              userId: user.id,
            ),
          ).called(1);
          verify(
            () => dbWorkoutSettingsService.deleteSettingsForUser(
              userId: user.id,
            ),
          ).called(1);
        },
      );
    },
  );
}
