import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/repository_impl/user_basic_info_repository_impl.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/entity/user_basic_info.dart';

import '../../creators/user_basic_info_creator.dart';
import '../../creators/user_dto_creator.dart';
import '../../mock/firebase/mock_firebase_user_service.dart';

void main() {
  final firebaseUserService = MockFirebaseUserService();
  late UserBasicInfoRepositoryImpl repository;

  setUpAll(() {
    GetIt.I.registerSingleton<firebase.FirebaseUserService>(
      firebaseUserService,
    );
  });

  setUp(() => repository = UserBasicInfoRepositoryImpl());

  tearDown(() {
    reset(firebaseUserService);
  });

  test(
    'get user basic info by user id, '
    'user exists in repository, '
    'should emit matching user from repo',
    () {
      final List<UserBasicInfo> existingUsers = [
        createUserBasicInfo(id: 'u1', name: 'name1', surname: 'surname1'),
        createUserBasicInfo(id: 'u2', name: 'name2', surname: 'surname2'),
      ];
      repository = UserBasicInfoRepositoryImpl(initialData: existingUsers);

      final Stream<UserBasicInfo?> user$ =
          repository.getUserBasicInfoByUserId(userId: 'u1');

      expect(user$, emitsInOrder([existingUsers.first]));
    },
  );

  test(
    'get user basic info by user id, '
    'user does not exist in repository, '
    'should load user from db, add him to repository and emit',
    () {
      final List<UserBasicInfo> existingUsers = [
        createUserBasicInfo(id: 'u2', name: 'name2', surname: 'surname2'),
      ];
      final firebase.UserDto loadedUserDto = createUserDto(
        id: 'u1',
        gender: firebase.Gender.male,
        name: 'name1',
        surname: 'surname1',
        email: 'email1@example.com',
        coachId: 'c1',
      );
      final UserBasicInfo expectedUser = UserBasicInfo(
        id: loadedUserDto.id,
        gender: Gender.male,
        name: loadedUserDto.name,
        surname: loadedUserDto.surname,
        email: loadedUserDto.email,
        coachId: loadedUserDto.coachId,
      );
      repository = UserBasicInfoRepositoryImpl(initialData: existingUsers);
      firebaseUserService.mockLoadUserById(userDto: loadedUserDto);

      final Stream<UserBasicInfo?> user$ =
          repository.getUserBasicInfoByUserId(userId: 'u1');
      final Stream<List<UserBasicInfo>?> repositoryState$ =
          repository.dataStream$;

      expect(user$, emitsInOrder([expectedUser]));
      expect(
        repositoryState$,
        emitsInOrder([
          existingUsers,
          [...existingUsers, expectedUser],
        ]),
      );
    },
  );

  test(
    'get users basic info by coach id, '
    'should load users from db, add them to repository and should emit all users with matching coach id',
    () {
      const String coachId = 'c1';
      final List<UserBasicInfo> existingUsers = [
        createUserBasicInfo(id: 'u1', coachId: coachId),
        createUserBasicInfo(id: 'u2', coachId: coachId),
        createUserBasicInfo(id: 'u3', coachId: 'c2'),
        createUserBasicInfo(id: 'u4'),
      ];
      final List<firebase.UserDto> loadedUserDtos = [
        createUserDto(id: 'u5', coachId: coachId),
        createUserDto(id: 'u6', coachId: coachId),
      ];
      final List<UserBasicInfo> loadedUsersBasicInfo = [
        createUserBasicInfo(id: 'u5', coachId: coachId),
        createUserBasicInfo(id: 'u6', coachId: coachId),
      ];
      firebaseUserService.mockLoadUsersByCoachId(users: loadedUserDtos);
      repository = UserBasicInfoRepositoryImpl(initialData: existingUsers);

      final Stream<List<UserBasicInfo>?> users$ =
          repository.getUsersBasicInfoByCoachId(coachId: coachId);
      final Stream<List<UserBasicInfo>?> repositoryState$ =
          repository.dataStream$;

      expect(
        users$,
        emitsInOrder([
          [
            existingUsers.first,
            existingUsers[1],
            ...loadedUsersBasicInfo,
          ],
        ]),
      );
      expect(
        repositoryState$,
        emitsInOrder([
          existingUsers,
          [
            ...existingUsers,
            ...loadedUsersBasicInfo,
          ],
        ]),
      );
    },
  );
}
