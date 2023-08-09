import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/user_basic_info.dart';
import 'package:runnoter/domain/bloc/clients_search/clients_search_bloc.dart';
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
    'search text changed, '
    'should update search text in state',
    build: () => ClientsSearchBloc(),
    act: (bloc) => bloc.add(const ClientsSearchEventSearchTextChanged(
      searchText: 'searchText',
    )),
    expect: () => [
      const ClientsSearchState(
        status: BlocStatusComplete(),
        searchText: 'searchText',
      ),
    ],
  );

  blocTest(
    'search, '
    'search text is empty string, '
    'should do nothing',
    build: () => ClientsSearchBloc(),
    act: (bloc) => bloc.add(const ClientsSearchEventSearch()),
    expect: () => [],
  );

  blocTest(
    'search, '
    "should call user repository's method to search users and should updated found users in state",
    build: () => ClientsSearchBloc(
      state: const ClientsSearchState(
        status: BlocStatusComplete(),
        searchText: 'sea',
      ),
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
    act: (bloc) => bloc.add(const ClientsSearchEventSearch()),
    expect: () => [
      const ClientsSearchState(status: BlocStatusLoading(), searchText: 'sea'),
      const ClientsSearchState(
        status: BlocStatusComplete(),
        searchText: 'sea',
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
