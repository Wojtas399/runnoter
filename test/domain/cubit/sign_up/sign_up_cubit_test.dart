import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/entity/user.dart';
import 'package:runnoter/domain/additional_model/cubit_status.dart';
import 'package:runnoter/domain/additional_model/custom_exception.dart';
import 'package:runnoter/domain/cubit/sign_up/sign_up_cubit.dart';
import 'package:runnoter/domain/service/auth_service.dart';
import 'package:runnoter/domain/use_case/add_user_data_use_case.dart';

import '../../../mock/domain/service/mock_auth_service.dart';
import '../../../mock/domain/use_case/mock_add_user_data_use_case.dart';

void main() {
  final authService = MockAuthService();
  final addUserDataUseCase = MockAddUserDataUseCase();
  const AccountType accountType = AccountType.coach;
  const Gender gender = Gender.male;
  const String name = 'Jack';
  const String surname = 'Gadovsky';
  const String email = 'jack@example.com';
  final DateTime dateOfBirth = DateTime(2023, 1, 10);
  const String password = 'Password1!';

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
    build: () => SignUpCubit(),
    act: (cubit) => cubit.accountTypeChanged(accountType),
    expect: () => [
      const SignUpState(
        status: CubitStatusComplete(),
        accountType: accountType,
      ),
    ],
  );

  blocTest(
    'gender changed, '
    'should update gender in state',
    build: () => SignUpCubit(),
    act: (cubit) => cubit.genderChanged(gender),
    expect: () => [
      const SignUpState(
        status: CubitStatusComplete(),
        gender: gender,
      ),
    ],
  );

  blocTest(
    'name changed, '
    'should update name in state',
    build: () => SignUpCubit(),
    act: (cubit) => cubit.nameChanged(name),
    expect: () => [
      const SignUpState(
        status: CubitStatusComplete(),
        name: name,
      ),
    ],
  );

  blocTest(
    'surname changed, '
    'should update surname in state',
    build: () => SignUpCubit(),
    act: (cubit) => cubit.surnameChanged(surname),
    expect: () => [
      const SignUpState(
        status: CubitStatusComplete(),
        surname: surname,
      ),
    ],
  );

  blocTest(
    'email changed, '
    'should update email in state',
    build: () => SignUpCubit(),
    act: (cubit) => cubit.emailChanged(email),
    expect: () => [
      const SignUpState(
        status: CubitStatusComplete(),
        email: email,
      ),
    ],
  );

  blocTest(
    'date of birth changed, '
    'should update date of birth in state',
    build: () => SignUpCubit(),
    act: (cubit) => cubit.dateOfBirthChanged(dateOfBirth),
    expect: () => [
      SignUpState(
        status: const CubitStatusComplete(),
        dateOfBirth: dateOfBirth,
      ),
    ],
  );

  blocTest(
    'password changed, '
    'should update password in state',
    build: () => SignUpCubit(),
    act: (cubit) => cubit.passwordChanged(password),
    expect: () => [
      const SignUpState(
        status: CubitStatusComplete(),
        password: password,
      ),
    ],
  );

  blocTest(
    'password confirmation changed, '
    'should update password confirmation in initialState',
    build: () => SignUpCubit(),
    act: (cubit) => cubit.passwordConfirmationChanged(password),
    expect: () => [
      const SignUpState(
        status: CubitStatusComplete(),
        passwordConfirmation: password,
      ),
    ],
  );

  blocTest(
    'submit, '
    'submit button is disabled, '
    'should do nothing',
    build: () => SignUpCubit(
      initialState: SignUpState(
        status: const CubitStatusInitial(),
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
        password: password,
      ),
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [],
  );

  blocTest(
    'submit, '
    "should call auth service's method to sign up, use case to add user data, auth service's method to send email verification and should emit complete status with signed up info",
    build: () => SignUpCubit(
      initialState: SignUpState(
        status: const CubitStatusInitial(),
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
        password: password,
        passwordConfirmation: password,
      ),
    ),
    setUp: () {
      authService.mockSignUp(userId: 'u1');
      addUserDataUseCase.mock();
      authService.mockSendEmailVerification();
    },
    act: (bloc) => bloc.submit(),
    expect: () => [
      SignUpState(
        status: const CubitStatusLoading(),
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
        password: password,
        passwordConfirmation: password,
      ),
      SignUpState(
        status: const CubitStatusComplete<SignUpCubitInfo>(
          info: SignUpCubitInfo.signedUp,
        ),
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
        password: password,
        passwordConfirmation: password,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.signUp(email: email, password: password),
      ).called(1);
      verify(
        () => addUserDataUseCase.execute(
          accountType: accountType,
          userId: 'u1',
          gender: gender,
          name: name,
          surname: surname,
          email: email,
          dateOfBirth: dateOfBirth,
        ),
      ).called(1);
      verify(authService.sendEmailVerification).called(1);
    },
  );

  blocTest(
    'submit, '
    'auth exception with email already in use code, '
    'should emit error status with email already in use error',
    build: () => SignUpCubit(
      initialState: SignUpState(
        status: const CubitStatusInitial(),
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
        password: password,
        passwordConfirmation: password,
      ),
    ),
    setUp: () => authService.mockSignUp(
      throwable: const AuthException(
        code: AuthExceptionCode.emailAlreadyInUse,
      ),
    ),
    act: (bloc) => bloc.submit(),
    expect: () => [
      SignUpState(
        status: const CubitStatusLoading(),
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
        password: password,
        passwordConfirmation: password,
      ),
      SignUpState(
        status: const CubitStatusError<SignUpCubitError>(
          error: SignUpCubitError.emailAlreadyInUse,
        ),
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
        password: password,
        passwordConfirmation: password,
      ),
    ],
    verify: (_) => verify(
      () => authService.signUp(email: email, password: password),
    ).called(1),
  );

  blocTest(
    'submit, '
    'network exception with request failed code, '
    'should emit network request failed status',
    build: () => SignUpCubit(
      initialState: SignUpState(
        status: const CubitStatusInitial(),
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
        password: password,
        passwordConfirmation: password,
      ),
    ),
    setUp: () => authService.mockSignUp(
      throwable: const NetworkException(
        code: NetworkExceptionCode.requestFailed,
      ),
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [
      SignUpState(
        status: const CubitStatusLoading(),
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
        password: password,
        passwordConfirmation: password,
      ),
      SignUpState(
        status: const CubitStatusNoInternetConnection(),
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
        password: password,
        passwordConfirmation: password,
      ),
    ],
    verify: (_) => verify(
      () => authService.signUp(email: email, password: password),
    ).called(1),
  );

  blocTest(
    'submit, '
    'unknown exception, '
    'should emit error status with unknown error',
    build: () => SignUpCubit(
      initialState: SignUpState(
        status: const CubitStatusInitial(),
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
        password: password,
        passwordConfirmation: password,
      ),
    ),
    setUp: () => authService.mockSignUp(
      throwable: const UnknownException(message: 'unknown exception message'),
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [
      SignUpState(
        status: const CubitStatusLoading(),
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
        password: password,
        passwordConfirmation: password,
      ),
      SignUpState(
        status: const CubitStatusUnknownError(),
        accountType: accountType,
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        dateOfBirth: dateOfBirth,
        password: password,
        passwordConfirmation: password,
      ),
    ],
    errors: () => [
      const UnknownException(message: 'unknown exception message'),
    ],
    verify: (_) => verify(
      () => authService.signUp(email: email, password: password),
    ).called(1),
  );
}
