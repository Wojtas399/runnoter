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
  const String userId = 'u1';
  const String email = 'email@example.com';
  const AccountType accountType = AccountType.coach;
  const Gender gender = Gender.female;
  const String name = 'name';
  const String surname = 'surname';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerFactory<AddUserDataUseCase>(() => addUserDataUseCase);
  });

  tearDown(() {
    reset(authService);
    reset(addUserDataUseCase);
  });

  blocTest(
    'account type changed, '
    'should update account type in state',
    build: () => RequiredDataCompletionBloc(),
    act: (bloc) => bloc.add(const RequiredDataCompletionEventAccountTypeChanged(
      accountType: accountType,
    )),
    expect: () => [
      const RequiredDataCompletionState(
        status: BlocStatusComplete(),
        accountType: accountType,
      ),
    ],
  );

  blocTest(
    'gender changed, '
    'should update gender in state',
    build: () => RequiredDataCompletionBloc(),
    act: (bloc) => bloc.add(const RequiredDataCompletionEventGenderChanged(
      gender: gender,
    )),
    expect: () => [
      const RequiredDataCompletionState(
        status: BlocStatusComplete(),
        gender: gender,
      ),
    ],
  );

  blocTest(
    'name changed, '
    'should update name in state',
    build: () => RequiredDataCompletionBloc(),
    act: (bloc) => bloc.add(const RequiredDataCompletionEventNameChanged(
      name: name,
    )),
    expect: () => [
      const RequiredDataCompletionState(
        status: BlocStatusComplete(),
        name: name,
      ),
    ],
  );

  blocTest(
    'surname changed, '
    'should update surname in state',
    build: () => RequiredDataCompletionBloc(),
    act: (bloc) => bloc.add(const RequiredDataCompletionEventSurnameChanged(
      surname: surname,
    )),
    expect: () => [
      const RequiredDataCompletionState(
        status: BlocStatusComplete(),
        surname: surname,
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
    'logged user id is null, '
    'should emit no logged user status',
    build: () => RequiredDataCompletionBloc(
      state: const RequiredDataCompletionState(
        name: name,
        surname: surname,
      ),
    ),
    setUp: () {
      authService.mockGetLoggedUserId();
      authService.mockGetLoggedUserEmail(userEmail: email);
    },
    act: (bloc) => bloc.add(const RequiredDataCompletionEventSubmit()),
    expect: () => [
      const RequiredDataCompletionState(
        status: BlocStatusLoading(),
        name: name,
        surname: surname,
      ),
      const RequiredDataCompletionState(
        status: BlocStatusNoLoggedUser(),
        name: name,
        surname: surname,
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(() => authService.loggedUserEmail$).called(1);
    },
  );

  blocTest(
    'submit, '
    'logged user email is null, '
    'should emit no logged user status',
    build: () => RequiredDataCompletionBloc(
      state: const RequiredDataCompletionState(
        name: name,
        surname: surname,
      ),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: userId);
      authService.mockGetLoggedUserEmail();
    },
    act: (bloc) => bloc.add(const RequiredDataCompletionEventSubmit()),
    expect: () => [
      const RequiredDataCompletionState(
        status: BlocStatusLoading(),
        name: name,
        surname: surname,
      ),
      const RequiredDataCompletionState(
        status: BlocStatusNoLoggedUser(),
        name: name,
        surname: surname,
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(() => authService.loggedUserEmail$).called(1);
    },
  );

  blocTest(
    'submit, '
    "should call use case to add user data and should emit info that user's data has been added",
    build: () => RequiredDataCompletionBloc(
      state: const RequiredDataCompletionState(
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
      ),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: userId);
      authService.mockGetLoggedUserEmail(userEmail: email);
      addUserDataUseCase.mock();
    },
    act: (bloc) => bloc.add(const RequiredDataCompletionEventSubmit()),
    expect: () => [
      const RequiredDataCompletionState(
        status: BlocStatusLoading(),
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
      ),
      const RequiredDataCompletionState(
        status: BlocStatusComplete<RequiredDataCompletionBlocInfo>(
          info: RequiredDataCompletionBlocInfo.userDataAdded,
        ),
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(() => authService.loggedUserEmail$).called(1);
      verify(
        () => addUserDataUseCase.execute(
          userId: userId,
          accountType: accountType,
          gender: gender,
          name: name,
          surname: surname,
          email: email,
        ),
      ).called(1);
    },
  );
}
