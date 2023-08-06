import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/required_data_completion/required_data_completion_bloc.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/service/auth_service.dart';
import 'package:runnoter/domain/use_case/add_user_data_use_case.dart';

import '../../../mock/domain/service/mock_auth_service.dart';
import '../../../mock/domain/use_case/mock_add_user_data_use_case.dart';

void main() {
  final authService = MockAuthService();
  final addUserDataUseCase = MockAddUserDataUseCase();

  setUpAll(() {
    GetIt.I.registerSingleton<AuthService>(authService);
    GetIt.I.registerFactory<AddUserDataUseCase>(() => addUserDataUseCase);
  });

  tearDown(() {
    reset(authService);
    reset(addUserDataUseCase);
  });

  blocTest(
    'gender changed, '
    'should update gender in state',
    build: () => RequiredDataCompletionBloc(),
    act: (bloc) => bloc.add(const RequiredDataCompletionEventGenderChanged(
      gender: Gender.female,
    )),
    expect: () => [
      const RequiredDataCompletionState(
        status: BlocStatusComplete(),
        gender: Gender.female,
      ),
    ],
  );

  blocTest(
    'name changed, '
    'should update name in state',
    build: () => RequiredDataCompletionBloc(),
    act: (bloc) => bloc.add(const RequiredDataCompletionEventNameChanged(
      name: 'Jack',
    )),
    expect: () => [
      const RequiredDataCompletionState(
        status: BlocStatusComplete(),
        name: 'Jack',
      ),
    ],
  );

  blocTest(
    'surname changed, '
    'should update surname in state',
    build: () => RequiredDataCompletionBloc(),
    act: (bloc) => bloc.add(const RequiredDataCompletionEventSurnameChanged(
      surname: 'Erl',
    )),
    expect: () => [
      const RequiredDataCompletionState(
        status: BlocStatusComplete(),
        surname: 'Erl',
      ),
    ],
  );

  blocTest(
    'submit, '
    'data are invalid, '
    'should do nothing',
    build: () => RequiredDataCompletionBloc(),
    act: (bloc) => bloc.add(const RequiredDataCompletionEventSubmit()),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'logged user does not exist, '
    'should emit no logged user status',
    build: () => RequiredDataCompletionBloc(
      state: const RequiredDataCompletionState(
        gender: Gender.female,
        name: 'Ariana',
        surname: 'Novsky',
      ),
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const RequiredDataCompletionEventSubmit()),
    expect: () => [
      const RequiredDataCompletionState(
        status: BlocStatusLoading(),
        gender: Gender.female,
        name: 'Ariana',
        surname: 'Novsky',
      ),
      const RequiredDataCompletionState(
        status: BlocStatusNoLoggedUser(),
        gender: Gender.female,
        name: 'Ariana',
        surname: 'Novsky',
      ),
    ],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'submit, '
    "should call use case to add user data and should emit info that user's data has been added",
    build: () => RequiredDataCompletionBloc(
      state: const RequiredDataCompletionState(
        gender: Gender.female,
        name: 'Ariana',
        surname: 'Novsky',
      ),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      addUserDataUseCase.mock();
    },
    act: (bloc) => bloc.add(const RequiredDataCompletionEventSubmit()),
    expect: () => [
      const RequiredDataCompletionState(
        status: BlocStatusLoading(),
        gender: Gender.female,
        name: 'Ariana',
        surname: 'Novsky',
      ),
      const RequiredDataCompletionState(
        status: BlocStatusComplete<RequiredDataCompletionBlocInfo>(
          info: RequiredDataCompletionBlocInfo.userDataAdded,
        ),
        gender: Gender.female,
        name: 'Ariana',
        surname: 'Novsky',
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => addUserDataUseCase.execute(
          accountType: AccountType.runner,
          userId: 'u1',
          name: 'Ariana',
          surname: 'Novsky',
          gender: Gender.female,
        ),
      ).called(1);
    },
  );
}
