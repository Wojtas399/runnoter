import 'package:firebase/firebase.dart' as db;
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/implementation/repository/user_repository_impl.dart';
import 'package:runnoter/data/model/user.dart';

import '../../creators/activities_settings_dto.dart';
import '../../creators/appearance_settings_dto_creator.dart';
import '../../creators/user_creator.dart';
import '../../creators/user_dto_creator.dart';
import '../../creators/user_settings_creator.dart';
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
      final User expectedUser = createUser(id: userId);
      repository = UserRepositoryImpl(initialState: [expectedUser]);

      final Stream<User?> user$ = repository.getUserById(userId: userId);

      expect(user$, emits(expectedUser));
    },
  );

  test(
    'get user by id, '
    'user does not exist in state, '
    'should emit user loaded from remote db',
    () {
      final userDto = db.UserDto(
        id: userId,
        accountType: db.AccountType.coach,
        gender: db.Gender.male,
        name: 'name',
        surname: 'surname',
        email: 'email@example.com',
        dateOfBirth: DateTime(2023),
      );
      const appearanceSettingsDto = db.AppearanceSettingsDto(
        userId: userId,
        themeMode: db.ThemeMode.light,
        language: db.Language.polish,
      );
      const activitiesSettingsDto = db.ActivitiesSettingsDto(
        userId: userId,
        distanceUnit: db.DistanceUnit.kilometers,
        paceUnit: db.PaceUnit.minutesPerKilometer,
      );
      final User expectedUser = createUser(
        id: userId,
        accountType: AccountType.coach,
        gender: Gender.male,
        name: 'name',
        surname: 'surname',
        email: 'email@example.com',
        settings: createUserSettings(
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
        activitiesSettingsDto: activitiesSettingsDto,
      );

      final Stream<User?> user$ = repository.getUserById(userId: userId);

      expect(user$, emits(expectedUser));
    },
  );

  test(
    'add user, '
    'should call db methods to add user personal data, appearance settings, activities settings and should add user to repository',
    () async {
      const String name = 'name';
      const AccountType accountType = AccountType.runner;
      const db.AccountType dbAccountType = db.AccountType.runner;
      const Gender gender = Gender.male;
      const db.Gender dbGender = db.Gender.male;
      const String surname = 'surname';
      const String email = 'email@example.com';
      const String coachId = 'c1';
      const UserSettings settings = UserSettings(
        themeMode: ThemeMode.dark,
        language: Language.english,
        distanceUnit: DistanceUnit.miles,
        paceUnit: PaceUnit.milesPerHour,
      );
      const dbAppearanceSettings = db.AppearanceSettingsDto(
        userId: userId,
        themeMode: db.ThemeMode.dark,
        language: db.Language.english,
      );
      const dbActivitiesSettings = db.ActivitiesSettingsDto(
        userId: userId,
        distanceUnit: db.DistanceUnit.miles,
        paceUnit: db.PaceUnit.milesPerHour,
      );
      final User userToAdd = createUser(
        id: userId,
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        settings: settings,
        coachId: coachId,
      );
      final db.UserDto addedUserDto = db.UserDto(
        id: userId,
        accountType: dbAccountType,
        gender: dbGender,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: DateTime(2023),
        coachId: coachId,
      );
      final User addedUser = createUser(
        id: userId,
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        settings: settings,
        coachId: coachId,
      );
      dbUserService.mockAddUserData(addedUser: addedUserDto);
      dbAppearanceSettingsService.mockAddSettings(
        appearanceSettingsDto: dbAppearanceSettings,
      );
      dbActivitiesSettingsService.mockAddSettings(
        activitiesSettingsDto: dbActivitiesSettings,
      );

      await repository.addUser(user: userToAdd);
      final Stream<User?> user$ = repository.getUserById(userId: userId);

      expect(await user$.first, addedUser);
      verify(
        () => dbUserService.addUserData(
          userDto: db.UserDto(
            id: userId,
            accountType: dbAccountType,
            gender: dbGender,
            name: name,
            surname: surname,
            email: email,
            dateOfBirth: DateTime(2023),
            coachId: coachId,
          ),
        ),
      ).called(1);
      verify(
        () => dbAppearanceSettingsService.addSettings(
          appearanceSettingsDto: dbAppearanceSettings,
        ),
      ).called(1);
      verify(
        () => dbActivitiesSettingsService.addSettings(
          activitiesSettingsDto: dbActivitiesSettings,
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
        createUser(id: 'u2'),
        createUser(id: 'u3'),
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
      final UserSettings userSettings = createUserSettings(
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
    "should call db method to update user's data and should update user in repository",
    () async {
      const AccountType newAccountType = AccountType.coach;
      const db.AccountType newDbAccountType = db.AccountType.coach;
      const Gender newGender = Gender.male;
      const db.Gender newDbGender = db.Gender.male;
      const String newName = 'name';
      const String newSurname = 'surname';
      const String newEmail = 'new.email@example.com';
      const String newCoachId = 'c2';
      final UserSettings userSettings = createUserSettings(
        themeMode: ThemeMode.dark,
        language: Language.english,
        distanceUnit: DistanceUnit.miles,
        paceUnit: PaceUnit.milesPerHour,
      );
      final User existingUser = createUser(
        id: userId,
        accountType: AccountType.runner,
        name: 'username',
        surname: 'surname1',
        email: 'email@example.com',
        settings: userSettings,
        coachId: 'c1',
      );
      final updatedUserDto = db.UserDto(
        id: userId,
        accountType: newDbAccountType,
        gender: newDbGender,
        name: newName,
        surname: newSurname,
        email: newEmail,
        dateOfBirth: DateTime(2023),
        coachId: newCoachId,
      );
      final User expectedUpdatedUser = createUser(
        id: userId,
        accountType: newAccountType,
        gender: newGender,
        name: newName,
        surname: newSurname,
        email: newEmail,
        settings: userSettings,
        coachId: newCoachId,
      );
      repository = UserRepositoryImpl(initialState: [existingUser]);
      dbUserService.mockUpdateUserData(userDto: updatedUserDto);

      await repository.updateUser(
        userId: userId,
        accountType: newAccountType,
        gender: newGender,
        name: newName,
        surname: newSurname,
        email: newEmail,
        coachId: newCoachId,
        coachIdAsNull: false,
      );
      final Stream<User?> user$ = repository.getUserById(userId: userId);

      expect(await user$.first, expectedUpdatedUser);
      verify(
        () => dbUserService.updateUserData(
          userId: userId,
          accountType: newDbAccountType,
          gender: newDbGender,
          name: newName,
          surname: newSurname,
          email: newEmail,
          coachId: newCoachId,
          coachIdAsNull: false,
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
    'db methods do not return updated appearance and activities settings, '
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
      dbActivitiesSettingsService.mockUpdateSettings();
      repository = UserRepositoryImpl(initialState: [existingUser]);

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
    'should call db method to update appearance and activities settings and should update user in repository',
    () async {
      final User existingUser = createUser(
        id: userId,
        accountType: AccountType.coach,
        gender: Gender.male,
        name: 'name',
        surname: 'surname',
        email: 'email@example.com',
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
      final User expectedUpdatedUser = createUser(
        id: userId,
        accountType: existingUser.accountType,
        gender: existingUser.gender,
        name: existingUser.name,
        surname: existingUser.surname,
        email: existingUser.email,
        coachId: existingUser.coachId,
        settings: createUserSettings(
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
      const updatedActivitiesSettingsDto = db.ActivitiesSettingsDto(
        userId: userId,
        distanceUnit: newDbDistanceUnit,
        paceUnit: newDbPaceUnit,
      );
      dbAppearanceSettingsService.mockUpdateSettings(
        updatedAppearanceSettingsDto: updatedAppearanceSettingsDto,
      );
      dbActivitiesSettingsService.mockUpdateSettings(
        updatedActivitiesSettingsDto: updatedActivitiesSettingsDto,
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
    'refresh user by id',
    () async {
      const String userId = 'u1';
      final User existingUser = createUser(
        id: userId,
        name: 'name',
        surname: 'surname',
      );
      final db.UserDto updatedUserDto = createUserDto(
        id: userId,
        name: 'updated name',
        surname: 'updated surname',
      );
      final User updatedUser = createUser(
        id: userId,
        name: 'updated name',
        surname: 'updated surname',
      );
      repository = UserRepositoryImpl(initialState: [existingUser]);
      dbUserService.mockLoadUserById(userDto: updatedUserDto);
      dbAppearanceSettingsService.mockLoadSettingsByUserId(
        appearanceSettingsDto: createAppearanceSettingsDto(),
      );
      dbActivitiesSettingsService.mockLoadSettingsByUserId(
        activitiesSettingsDto: createActivitiesSettingsDto(),
      );

      final Stream<List<User>?> repoState$ = repository.dataStream$;
      repository.refreshUserById(userId: userId);

      expect(
        repoState$,
        emitsInOrder([
          [existingUser],
          [updatedUser],
        ]),
      );
    },
  );

  test(
    'delete user, '
    'should call db methods to delete user data, appearance settings and activities settings and then should delete user from repository',
    () async {
      final User user = createUser(id: userId);
      dbUserService.mockLoadUserById();
      dbUserService.mockDeleteUserData();
      dbAppearanceSettingsService.mockDeleteSettingsForUser();
      dbActivitiesSettingsService.mockDeleteSettingsForUser();
      repository = UserRepositoryImpl(
        initialState: [user],
      );

      final Stream<User?> user$ = repository.getUserById(userId: user.id);
      await repository.deleteUser(userId: user.id);

      expect(user$, emits(null));
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
