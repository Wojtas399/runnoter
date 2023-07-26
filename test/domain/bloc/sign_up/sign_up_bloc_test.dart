import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/custom_exception.dart';
import 'package:runnoter/domain/bloc/sign_up/sign_up_bloc.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/service/auth_service.dart';
import 'package:runnoter/domain/use_case/add_user_data_use_case.dart';

import '../../../mock/domain/service/mock_auth_service.dart';
import '../../../mock/domain/use_case/mock_add_user_data_use_case.dart';

void main() {
  final authService = MockAuthService();
  final addUserDataUseCase = MockAddUserDataUseCase();
  const Gender gender = Gender.male;
  const String name = 'Jack';
  const String surname = 'Gadovsky';
  const String email = 'jack@example.com';
  const String password = 'Password1!';

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
    build: () => SignUpBloc(),
    act: (bloc) => bloc.add(const SignUpEventGenderChanged(gender: gender)),
    expect: () => [
      const SignUpState(
        status: BlocStatusComplete(),
        gender: gender,
      ),
    ],
  );

  blocTest(
    'name changed, '
    'should update name in state',
    build: () => SignUpBloc(),
    act: (bloc) => bloc.add(const SignUpEventNameChanged(name: name)),
    expect: () => [
      const SignUpState(
        status: BlocStatusComplete(),
        name: name,
      ),
    ],
  );

  blocTest(
    'surname changed, '
    'should update surname in state',
    build: () => SignUpBloc(),
    act: (bloc) => bloc.add(const SignUpEventSurnameChanged(surname: surname)),
    expect: () => [
      const SignUpState(
        status: BlocStatusComplete(),
        surname: surname,
      ),
    ],
  );

  blocTest(
    'email changed, '
    'should update email in state',
    build: () => SignUpBloc(),
    act: (bloc) => bloc.add(const SignUpEventEmailChanged(email: email)),
    expect: () => [
      const SignUpState(
        status: BlocStatusComplete(),
        email: email,
      ),
    ],
  );

  blocTest(
    'password changed, '
    'should update password in state',
    build: () => SignUpBloc(),
    act: (bloc) => bloc.add(const SignUpEventPasswordChanged(
      password: password,
    )),
    expect: () => [
      const SignUpState(
        status: BlocStatusComplete(),
        password: password,
      ),
    ],
  );

  blocTest(
    'password confirmation changed, '
    'should update password confirmation in state',
    build: () => SignUpBloc(),
    act: (bloc) => bloc.add(const SignUpEventPasswordConfirmationChanged(
      passwordConfirmation: password,
    )),
    expect: () => [
      const SignUpState(
        status: BlocStatusComplete(),
        passwordConfirmation: password,
      ),
    ],
  );

  blocTest(
    'submit, '
    'submit button is disabled, '
    'should do nothing',
    build: () => SignUpBloc(
      state: const SignUpState(
        status: BlocStatusInitial(),
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        password: password,
      ),
    ),
    act: (bloc) => bloc.add(const SignUpEventSubmit()),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'should call auth service method to sign up and use case to add user data and should emit complete status with signed up info',
    build: () => SignUpBloc(
      state: const SignUpState(
        status: BlocStatusInitial(),
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        password: password,
        passwordConfirmation: password,
      ),
    ),
    setUp: () {
      authService.mockSignUp(userId: 'u1');
      addUserDataUseCase.mock();
    },
    act: (bloc) => bloc.add(const SignUpEventSubmit()),
    expect: () => [
      const SignUpState(
        status: BlocStatusLoading(),
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        password: password,
        passwordConfirmation: password,
      ),
      const SignUpState(
        status: BlocStatusComplete<SignUpBlocInfo>(
          info: SignUpBlocInfo.signedUp,
        ),
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        password: password,
        passwordConfirmation: password,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.signUp(
          email: email,
          password: password,
        ),
      ).called(1);
      verify(
        () => addUserDataUseCase.execute(
          userId: 'u1',
          gender: gender,
          name: name,
          surname: surname,
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'auth exception with email already in use code, '
    'should emit error status with email already in use error',
    build: () => SignUpBloc(
      state: const SignUpState(
        status: BlocStatusInitial(),
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        password: password,
        passwordConfirmation: password,
      ),
    ),
    setUp: () => authService.mockSignUp(
      throwable: const AuthException(
        code: AuthExceptionCode.emailAlreadyInUse,
      ),
    ),
    act: (bloc) => bloc.add(const SignUpEventSubmit()),
    expect: () => [
      const SignUpState(
        status: BlocStatusLoading(),
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        password: password,
        passwordConfirmation: password,
      ),
      const SignUpState(
        status: BlocStatusError<SignUpBlocError>(
          error: SignUpBlocError.emailAlreadyInUse,
        ),
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        password: password,
        passwordConfirmation: password,
      ),
    ],
    verify: (_) => verify(
      () => authService.signUp(
        email: email,
        password: password,
      ),
    ).called(1),
  );

  blocTest(
    'submit, '
    'network exception with request failed code, '
    'should emit network request failed status',
    build: () => SignUpBloc(
      state: const SignUpState(
        status: BlocStatusInitial(),
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        password: password,
        passwordConfirmation: password,
      ),
    ),
    setUp: () => authService.mockSignUp(
      throwable: const NetworkException(
        code: NetworkExceptionCode.requestFailed,
      ),
    ),
    act: (bloc) => bloc.add(const SignUpEventSubmit()),
    expect: () => [
      const SignUpState(
        status: BlocStatusLoading(),
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        password: password,
        passwordConfirmation: password,
      ),
      const SignUpState(
        status: BlocStatusNetworkRequestFailed(),
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        password: password,
        passwordConfirmation: password,
      ),
    ],
    verify: (_) => verify(
      () => authService.signUp(
        email: email,
        password: password,
      ),
    ).called(1),
  );

  blocTest(
    'submit, '
    'unknown exception, '
    'should emit error status with unknown error',
    build: () => SignUpBloc(
      state: const SignUpState(
        status: BlocStatusInitial(),
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        password: password,
        passwordConfirmation: password,
      ),
    ),
    setUp: () => authService.mockSignUp(
      throwable: const UnknownException(
        message: 'unknown exception message',
      ),
    ),
    act: (bloc) => bloc.add(const SignUpEventSubmit()),
    expect: () => [
      const SignUpState(
        status: BlocStatusLoading(),
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        password: password,
        passwordConfirmation: password,
      ),
      const SignUpState(
        status: BlocStatusUnknownError(),
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        password: password,
        passwordConfirmation: password,
      ),
    ],
    errors: () => ['unknown exception message'],
    verify: (_) => verify(
      () => authService.signUp(
        email: email,
        password: password,
      ),
    ).called(1),
  );
}
