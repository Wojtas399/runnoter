import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/repository_impl/user_repository_impl.dart';
import 'package:runnoter/domain/model/user.dart';

import '../../mock/firebase/mock_firebase_user_service.dart';
import '../../util/user_creator.dart';

void main() {
  final firebaseUserService = MockFirebaseUserService();
  late UserRepositoryImpl repository;

  UserRepositoryImpl createRepository({
    List<User>? initialState,
  }) {
    return UserRepositoryImpl(
      firebaseUserService: firebaseUserService,
      initialState: initialState,
    );
  }

  setUp(() {
    repository = createRepository();
  });

  tearDown(() {
    reset(firebaseUserService);
  });

  test(
    'get user by id, '
    'user exists in state, '
    'should emit user from state and should not call firebase method to load user',
    () {
      final User expectedUser = createUser(id: 'u1');
      repository = createRepository(
        initialState: [expectedUser],
      );

      final Stream<User?> user$ = repository.getUserById(
        userId: expectedUser.id,
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
          userId: expectedUser.id,
        ),
      );
    },
  );

  test(
    'get user by id, '
    'user does not exist in state, '
    'should call firebase method to load user and should emit loaded user',
    () {
      const String userId = 'u1';
      const UserDto userDto = UserDto(
        id: userId,
        name: 'name',
        surname: 'surname',
      );
      const User expectedUser = User(
        id: userId,
        name: 'name',
        surname: 'surname',
      );
      firebaseUserService.mockLoadUserById(
        userDto: userDto,
      );

      final Stream<User?> user$ = repository.getUserById(userId: userId);
      user$.listen((event) {});

      expect(
        user$,
        emitsInOrder(
          [null, expectedUser],
        ),
      );
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
      const UserDto userDto = UserDto(
        id: userId,
        name: name,
        surname: surname,
      );
      const User existingUser = User(
        id: userId,
        name: 'username',
        surname: 'surname1',
      );
      const User updatedUser = User(
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
    'should call firebase method to update user and should add user to repository state',
    () async {
      const String userId = 'u1';
      const String name = 'name';
      const String surname = 'surname';
      const UserDto userDto = UserDto(
        id: userId,
        name: name,
        surname: surname,
      );
      const User updatedUser = User(
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
}
