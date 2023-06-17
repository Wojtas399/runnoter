import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/custom_exception.dart';
import 'package:runnoter/domain/bloc/sign_up/sign_up_bloc.dart';
import 'package:runnoter/domain/entity/settings.dart';

import '../../../creators/settings_creator.dart';
import '../../../creators/user_creator.dart';
import '../../../mock/domain/repository/mock_user_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();
  const String name = 'Jack';
  const String surname = 'Gadovsky';
  const String email = 'jack@example.com';
  const String password = 'Password1!';

  SignUpBloc createBloc({
    String name = '',
    String surname = '',
    String email = '',
    String password = '',
  }) {
    return SignUpBloc(
      authService: authService,
      userRepository: userRepository,
      name: name,
      surname: surname,
      email: email,
      password: password,
    );
  }

  SignUpState createState({
    BlocStatus status = const BlocStatusInitial(),
    String name = '',
    String surname = '',
    String email = '',
    String password = '',
    String passwordConfirmation = '',
  }) {
    return SignUpState(
      status: status,
      name: name,
      surname: surname,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }

  tearDown(() {
    reset(authService);
    reset(userRepository);
  });

  blocTest(
    'name changed, '
    'should update username in state',
    build: () => createBloc(),
    act: (SignUpBloc bloc) => bloc.add(
      const SignUpEventNameChanged(
        name: name,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        name: name,
      ),
    ],
  );

  blocTest(
    'surname changed, '
    'should update surname in state',
    build: () => createBloc(),
    act: (SignUpBloc bloc) => bloc.add(
      const SignUpEventSurnameChanged(
        surname: surname,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        surname: surname,
      ),
    ],
  );

  blocTest(
    'email changed, '
    'should update email in state',
    build: () => createBloc(),
    act: (SignUpBloc bloc) => bloc.add(
      const SignUpEventEmailChanged(
        email: email,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        email: email,
      ),
    ],
  );

  blocTest(
    'password changed, '
    'should update password in state',
    build: () => createBloc(),
    act: (SignUpBloc bloc) => bloc.add(
      const SignUpEventPasswordChanged(
        password: password,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        password: password,
      ),
    ],
  );

  blocTest(
    'password confirmation changed, '
    'should update password confirmation in state',
    build: () => createBloc(),
    act: (SignUpBloc bloc) => bloc.add(
      const SignUpEventPasswordConfirmationChanged(
        passwordConfirmation: password,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        passwordConfirmation: password,
      ),
    ],
  );

  blocTest(
    'submit, '
    'should call auth service method to sign up and user repository method to add user with default settings, and should emit complete status with signed up info',
    build: () => createBloc(
      name: name,
      surname: surname,
      email: email,
      password: password,
    ),
    setUp: () {
      authService.mockSignUp(
        userId: 'u1',
      );
      userRepository.mockAddUser();
    },
    act: (SignUpBloc bloc) => bloc.add(
      const SignUpEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        name: name,
        surname: surname,
        email: email,
        password: password,
      ),
      createState(
        status: const BlocStatusComplete<SignUpBlocInfo>(
          info: SignUpBlocInfo.signedUp,
        ),
        name: name,
        surname: surname,
        email: email,
        password: password,
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
        () => userRepository.addUser(
          user: createUser(
            id: 'u1',
            name: name,
            surname: surname,
            settings: createSettings(
              themeMode: ThemeMode.light,
              language: Language.polish,
              distanceUnit: DistanceUnit.kilometers,
              paceUnit: PaceUnit.minutesPerKilometer,
            ),
          ),
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'auth exception with email already in use code, '
    'should emit error status with email already in use error',
    build: () => createBloc(
      name: name,
      surname: surname,
      email: email,
      password: password,
    ),
    setUp: () {
      authService.mockSignUp(
        throwable: const AuthException(
          code: AuthExceptionCode.emailAlreadyInUse,
        ),
      );
    },
    act: (SignUpBloc bloc) => bloc.add(
      const SignUpEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        name: name,
        surname: surname,
        email: email,
        password: password,
      ),
      createState(
        status: const BlocStatusError<SignUpBlocError>(
          error: SignUpBlocError.emailAlreadyInUse,
        ),
        name: name,
        surname: surname,
        email: email,
        password: password,
      ),
    ],
    verify: (_) {
      verify(
        () => authService.signUp(
          email: email,
          password: password,
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'network exception with request failed code, '
    'should emit network request failed status',
    build: () => createBloc(
      name: name,
      surname: surname,
      email: email,
      password: password,
    ),
    setUp: () => authService.mockSignUp(
      throwable: const NetworkException(
        code: NetworkExceptionCode.requestFailed,
      ),
    ),
    act: (SignUpBloc bloc) => bloc.add(
      const SignUpEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        name: name,
        surname: surname,
        email: email,
        password: password,
      ),
      createState(
        status: const BlocStatusNetworkRequestFailed(),
        name: name,
        surname: surname,
        email: email,
        password: password,
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
    build: () => createBloc(
      name: name,
      surname: surname,
      email: email,
      password: password,
    ),
    setUp: () {
      authService.mockSignUp(
        throwable: const UnknownException(
          message: 'unknown exception message',
        ),
      );
    },
    act: (SignUpBloc bloc) => bloc.add(
      const SignUpEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        name: name,
        surname: surname,
        email: email,
        password: password,
      ),
      createState(
        status: const BlocStatusUnknownError(),
        name: name,
        surname: surname,
        email: email,
        password: password,
      ),
    ],
    errors: () => [
      'unknown exception message',
    ],
    verify: (_) {
      verify(
        () => authService.signUp(
          email: email,
          password: password,
        ),
      ).called(1);
    },
  );
}
