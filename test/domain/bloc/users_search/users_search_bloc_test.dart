import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/user_basic_info.dart';
import 'package:runnoter/domain/bloc/users_search/users_search_bloc.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/repository/user_repository.dart';

import '../../../creators/user_creator.dart';
import '../../../mock/domain/repository/mock_user_repository.dart';

void main() {
  final userRepository = MockUserRepository();

  setUpAll(() {
    GetIt.I.registerSingleton<UserRepository>(userRepository);
  });

  tearDown(() {
    reset(userRepository);
  });

  blocTest(
    'search, '
    'search text is empty string, '
    'should set found users as null',
    build: () => UsersSearchBloc(
      state: const UsersSearchState(
        status: BlocStatusComplete(),
        foundUsers: [],
      ),
    ),
    act: (bloc) => bloc.add(const UsersSearchEventSearch(
      searchText: '',
    )),
    expect: () => [
      const UsersSearchState(status: BlocStatusComplete(), foundUsers: null),
    ],
  );

  blocTest(
    'search, '
    "should call user repository's method to search users and should updated found users in state",
    build: () => UsersSearchBloc(
      state: const UsersSearchState(status: BlocStatusComplete()),
    ),
    setUp: () => userRepository.mockSearchForUsers(
      users: [
        createUser(
          id: 'u1',
          gender: Gender.male,
          name: 'name1',
          surname: 'surname1',
          email: 'email1@example.com',
        ),
        createUser(
          id: 'u2',
          gender: Gender.female,
          name: 'name2',
          surname: 'surname2',
          email: 'email2@example.com',
        ),
      ],
    ),
    act: (bloc) => bloc.add(const UsersSearchEventSearch(searchText: 'sea')),
    expect: () => [
      const UsersSearchState(status: BlocStatusLoading()),
      const UsersSearchState(
        status: BlocStatusComplete(),
        foundUsers: [
          UserBasicInfo(
            id: 'u1',
            gender: Gender.male,
            name: 'name1',
            surname: 'surname1',
            email: 'email1@example.com',
          ),
          UserBasicInfo(
            id: 'u2',
            gender: Gender.female,
            name: 'name2',
            surname: 'surname2',
            email: 'email2@example.com',
          ),
        ],
      ),
    ],
    verify: (_) => verify(
      () => userRepository.searchForUsers(
        name: 'sea',
        surname: 'sea',
        email: 'sea',
      ),
    ).called(1),
  );
}
