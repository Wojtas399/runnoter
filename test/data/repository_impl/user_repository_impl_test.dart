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
    'should emit user from state and should not call db method to load user',
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
    'should call firebase method to load user, should add loaded user to repository state and should emit loaded user',
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
    'add user, '
    'should call db methods to add user personal data, appearance settings, workout settings and should add user to repository state',
    () async {
      const String userId = 'u1';
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
    'update user, '
    'user exists in repository'
    'should call db method to update user and should update user in repository state',
    () async {
      const String name = 'name';
      const String surname = 'surname';
      const updatedUserDto = db.UserDto(
        id: userId,
        name: name,
        surname: surname,
      );
      final User existingUser = createUser(
        id: userId,
        name: 'username',
        surname: 'surname1',
      );
      final User updatedUser = createUser(
        id: userId,
        name: name,
        surname: surname,
      );
      dbUserService.mockUpdateUserData(userDto: updatedUserDto);
      repository = createRepository(initialState: [existingUser]);

      await repository.updateUser(
        userId: userId,
        name: name,
        surname: surname,
      );
      final Stream<User?> user$ = repository.getUserById(userId: userId);

      expect(await user$.first, updatedUser);
      verify(
        () => dbUserService.updateUserData(
          userId: userId,
          name: name,
          surname: surname,
        ),
      ).called(1);
    },
  );

  test(
    'update user, '
    'user does not exist in repository'
    'should call db method to update user, should load user settings and should add user to repository state',
    () async {
      const String userId = 'u1';
      const String name = 'name';
      const String surname = 'surname';
      const db.UserDto userDto = db.UserDto(
        id: userId,
        name: name,
        surname: surname,
      );
      final User updatedUser = createUser(
        id: userId,
        name: name,
        surname: surname,
      );
      dbUserService.mockUpdateUserData(userDto: userDto);

      await repository.updateUser(
        userId: userId,
        name: name,
        surname: surname,
      );
      final Stream<User?> user$ = repository.getUserById(userId: userId);

      expect(await user$.first, updatedUser);
      verify(
        () => dbUserService.updateUserData(
          userId: userId,
          name: name,
          surname: surname,
        ),
      ).called(1);
    },
  );

  test(
    'delete user, '
    'should call db method to delete user data and should delete user from repository state',
    () {
      final User user = createUser(id: 'u1');
      dbUserService.mockDeleteUserData();
      repository = createRepository(
        initialState: [user],
      );

      final Stream<User?> user$ = repository.getUserById(userId: user.id);
      repository.deleteUser(userId: user.id);

      expect(
        user$,
        emitsInOrder(
          [user, null],
        ),
      );
      verify(
        () => dbUserService.deleteUserData(
          userId: user.id,
        ),
      ).called(1);
    },
  );
}
