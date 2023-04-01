import 'package:firebase/firebase.dart' as firebase;
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
  final firebaseUserService = MockFirebaseUserService();
  final firebaseAppearanceSettingsService =
      MockFirebaseAppearanceSettingsService();
  final firebaseWorkoutSettingsService = MockFirebaseWorkoutSettingsService();
  late UserRepositoryImpl repository;
  const String userId = 'u1';

  UserRepositoryImpl createRepository({
    List<User>? initialState,
  }) {
    return UserRepositoryImpl(
      firebaseUserService: firebaseUserService,
      firebaseAppearanceSettingsService: firebaseAppearanceSettingsService,
      firebaseWorkoutSettingsService: firebaseWorkoutSettingsService,
      initialState: initialState,
    );
  }

  setUp(() {
    repository = createRepository();
  });

  tearDown(() {
    reset(firebaseUserService);
    reset(firebaseAppearanceSettingsService);
    reset(firebaseWorkoutSettingsService);
  });

  test(
    'get user by id, '
    'user exists in state, '
    'should emit user from state and should not call firebase method to load user',
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
        () => firebaseUserService.loadUserById(
          userId: userId,
        ),
      );
      verifyNever(
        () => firebaseAppearanceSettingsService.loadSettingsByUserId(
          userId: userId,
        ),
      );
      verifyNever(
        () => firebaseWorkoutSettingsService.loadSettingsByUserId(
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
      const userDto = firebase.UserDto(
        id: userId,
        name: 'name',
        surname: 'surname',
      );
      const appearanceSettingsDto = firebase.AppearanceSettingsDto(
        userId: userId,
        themeMode: firebase.ThemeMode.light,
        language: firebase.Language.polish,
      );
      const workoutSettingsDto = firebase.WorkoutSettingsDto(
        userId: userId,
        distanceUnit: firebase.DistanceUnit.kilometers,
        paceUnit: firebase.PaceUnit.minutesPerKilometer,
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
      firebaseUserService.mockLoadUserById(
        userDto: userDto,
      );
      firebaseAppearanceSettingsService.mockLoadSettingsByUserId(
        appearanceSettingsDto: appearanceSettingsDto,
      );
      firebaseWorkoutSettingsService.mockLoadSettingsByUserId(
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
          () => firebaseUserService.loadUserById(
            userId: userId,
          ),
        ).called(1);
        verify(
          () => firebaseAppearanceSettingsService.loadSettingsByUserId(
            userId: userId,
          ),
        ).called(1);
        verify(
          () => firebaseWorkoutSettingsService.loadSettingsByUserId(
            userId: userId,
          ),
        ).called(1);
      });
    },
  );

  test(
    'add user, '
    'should call firebase methods to add user personal data, appearance settings, workout settings and should add user to repository state',
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
      firebaseUserService.mockAddUserPersonalData();
      firebaseAppearanceSettingsService.mockAddSettings();
      firebaseWorkoutSettingsService.mockAddSettings();

      await repository.addUser(user: userToAdd);
      final Stream<User?> user$ = repository.getUserById(
        userId: userToAdd.id,
      );

      expect(await user$.first, userToAdd);
      verify(
        () => firebaseUserService.addUserPersonalData(
          userDto: const firebase.UserDto(
            id: userId,
            name: 'username',
            surname: 'surname',
          ),
        ),
      ).called(1);
      verify(
        () => firebaseAppearanceSettingsService.addSettings(
          appearanceSettingsDto: const firebase.AppearanceSettingsDto(
            userId: userId,
            themeMode: firebase.ThemeMode.light,
            language: firebase.Language.english,
          ),
        ),
      ).called(1);
      verify(
        () => firebaseWorkoutSettingsService.addSettings(
          workoutSettingsDto: const firebase.WorkoutSettingsDto(
            userId: userId,
            distanceUnit: firebase.DistanceUnit.kilometers,
            paceUnit: firebase.PaceUnit.minutesPerKilometer,
          ),
        ),
      ).called(1);
    },
  );

  test(
    'update user, '
    'user exists in repository'
    'should call firebase method to update user and should update user in repository state',
    () async {
      const String userId = 'u1';
      const String name = 'name';
      const String surname = 'surname';
      const firebase.UserDto userDto = firebase.UserDto(
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
      firebaseUserService.mockUpdateUserData(userDto: userDto);
      repository = createRepository(initialState: [existingUser]);

      await repository.updateUser(
        userId: userId,
        name: name,
        surname: surname,
      );
      final Stream<User?> user$ = repository.getUserById(userId: userId);

      expect(await user$.first, updatedUser);
      verify(
        () => firebaseUserService.updateUserData(
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
    'should call firebase method to update user, should load user settings and should add user to repository state',
    () async {
      const String userId = 'u1';
      const String name = 'name';
      const String surname = 'surname';
      const firebase.UserDto userDto = firebase.UserDto(
        id: userId,
        name: name,
        surname: surname,
      );
      final User updatedUser = createUser(
        id: userId,
        name: name,
        surname: surname,
      );
      firebaseUserService.mockUpdateUserData(userDto: userDto);

      await repository.updateUser(
        userId: userId,
        name: name,
        surname: surname,
      );
      final Stream<User?> user$ = repository.getUserById(userId: userId);

      expect(await user$.first, updatedUser);
      verify(
        () => firebaseUserService.updateUserData(
          userId: userId,
          name: name,
          surname: surname,
        ),
      ).called(1);
    },
  );

  test(
    'delete user, '
    'should call firebase method to delete user data and should delete user from repository state',
    () {
      final User user = createUser(id: 'u1');
      firebaseUserService.mockDeleteUserData();
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
        () => firebaseUserService.deleteUserData(
          userId: user.id,
        ),
      ).called(1);
    },
  );
}
