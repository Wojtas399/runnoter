import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/entity/user.dart';
import 'package:runnoter/data/interface/service/auth_service.dart';
import 'package:runnoter/domain/additional_model/cubit_status.dart';
import 'package:runnoter/domain/use_case/add_user_data_use_case.dart';
import 'package:runnoter/ui/feature/dialog/required_data_completion/cubit/required_data_completion_cubit.dart';

import '../../../../mock/domain/service/mock_auth_service.dart';
import '../../../../mock/domain/use_case/mock_add_user_data_use_case.dart';

void main() {
  final authService = MockAuthService();
  final addUserDataUseCase = MockAddUserDataUseCase();
  const String userId = 'u1';
  const String email = 'email@example.com';
  const AccountType accountType = AccountType.coach;
  const Gender gender = Gender.female;
  const String name = 'name';
  const String surname = 'surname';
  final DateTime dateOfBirth = DateTime(2023, 1, 10);

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
    build: () => RequiredDataCompletionCubit(),
    act: (cubit) => cubit.accountTypeChanged(accountType),
    expect: () => [
      const RequiredDataCompletionState(
        status: CubitStatusComplete(),
        accountType: accountType,
      ),
    ],
  );

  blocTest(
    'gender changed, '
    'should update gender in state',
    build: () => RequiredDataCompletionCubit(),
    act: (cubit) => cubit.genderChanged(gender),
    expect: () => [
      const RequiredDataCompletionState(
        status: CubitStatusComplete(),
        gender: gender,
      ),
    ],
  );

  blocTest(
    'name changed, '
    'should update name in state',
    build: () => RequiredDataCompletionCubit(),
    act: (cubit) => cubit.nameChanged(name),
    expect: () => [
      const RequiredDataCompletionState(
        status: CubitStatusComplete(),
        name: name,
      ),
    ],
  );

  blocTest(
    'surname changed, '
    'should update surname in state',
    build: () => RequiredDataCompletionCubit(),
    act: (cubit) => cubit.surnameChanged(surname),
    expect: () => [
      const RequiredDataCompletionState(
        status: CubitStatusComplete(),
        surname: surname,
      ),
    ],
  );

  blocTest(
    'date of birth changed, '
    'should update dateOfBirth in state',
    build: () => RequiredDataCompletionCubit(),
    act: (cubit) => cubit.dateOfBirthChanged(dateOfBirth),
    expect: () => [
      RequiredDataCompletionState(
        status: const CubitStatusComplete(),
        dateOfBirth: dateOfBirth,
      ),
    ],
  );

  blocTest(
    'submit, '
    'data are invalid, '
    'should do nothing',
    build: () => RequiredDataCompletionCubit(),
    act: (cubit) => cubit.submit(),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'logged user id is null, '
    'should emit no logged user status',
    build: () => RequiredDataCompletionCubit(
      initialState: RequiredDataCompletionState(
        name: name,
        surname: surname,
        dateOfBirth: dateOfBirth,
      ),
    ),
    setUp: () {
      authService.mockGetLoggedUserId();
      authService.mockGetLoggedUserEmail(userEmail: email);
    },
    act: (cubit) => cubit.submit(),
    expect: () => [
      RequiredDataCompletionState(
        status: const CubitStatusLoading(),
        name: name,
        surname: surname,
        dateOfBirth: dateOfBirth,
      ),
      RequiredDataCompletionState(
        status: const CubitStatusNoLoggedUser(),
        name: name,
        surname: surname,
        dateOfBirth: dateOfBirth,
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
    build: () => RequiredDataCompletionCubit(
      initialState: RequiredDataCompletionState(
        name: name,
        surname: surname,
        dateOfBirth: dateOfBirth,
      ),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: userId);
      authService.mockGetLoggedUserEmail();
    },
    act: (cubit) => cubit.submit(),
    expect: () => [
      RequiredDataCompletionState(
        status: const CubitStatusLoading(),
        name: name,
        surname: surname,
        dateOfBirth: dateOfBirth,
      ),
      RequiredDataCompletionState(
        status: const CubitStatusNoLoggedUser(),
        name: name,
        surname: surname,
        dateOfBirth: dateOfBirth,
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
    build: () => RequiredDataCompletionCubit(
      initialState: RequiredDataCompletionState(
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
        dateOfBirth: dateOfBirth,
      ),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: userId);
      authService.mockGetLoggedUserEmail(userEmail: email);
      addUserDataUseCase.mock();
    },
    act: (cubit) => cubit.submit(),
    expect: () => [
      RequiredDataCompletionState(
        status: const CubitStatusLoading(),
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
        dateOfBirth: dateOfBirth,
      ),
      RequiredDataCompletionState(
        status: const CubitStatusComplete<RequiredDataCompletionCubitInfo>(
          info: RequiredDataCompletionCubitInfo.userDataAdded,
        ),
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
        dateOfBirth: dateOfBirth,
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
          dateOfBirth: dateOfBirth,
        ),
      ).called(1);
    },
  );
}
