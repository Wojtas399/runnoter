import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/custom_exception.dart';
import 'package:runnoter/domain/bloc/sign_up/sign_up_bloc.dart';
import 'package:runnoter/domain/entity/settings.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/service/auth_service.dart';

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
    Gender gender = Gender.male,
    String name = '',
    String surname = '',
    String email = '',
    String password = '',
    String passwordConfirmation = '',
  }) {
    return SignUpBloc(
      userRepository: userRepository,
      state: SignUpState(
        status: const BlocStatusInitial(),
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      ),
    );
  }

  SignUpState createState({
    BlocStatus status = const BlocStatusInitial(),
    Gender gender = Gender.male,
    String name = '',
    String surname = '',
    String email = '',
    String password = '',
    String passwordConfirmation = '',
  }) {
    return SignUpState(
      status: status,
      gender: gender,
      name: name,
      surname: surname,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }

  setUpAll(() {
    GetIt.I.registerSingleton<AuthService>(authService);
  });

  tearDown(() {
    reset(authService);
    reset(userRepository);
  });

  blocTest(
    'gender changed, '
    'should update gender in state',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const SignUpEventGenderChanged(
      gender: Gender.female,
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        gender: Gender.female,
      ),
    ],
  );

  blocTest(
    'name changed, '
    'should update name in state',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const SignUpEventNameChanged(name: name)),
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
    act: (bloc) => bloc.add(const SignUpEventSurnameChanged(surname: surname)),
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
    act: (bloc) => bloc.add(const SignUpEventEmailChanged(email: email)),
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
    act: (bloc) => bloc.add(const SignUpEventPasswordChanged(
      password: password,
    )),
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
    act: (bloc) => bloc.add(const SignUpEventPasswordConfirmationChanged(
      passwordConfirmation: password,
    )),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        passwordConfirmation: password,
      ),
    ],
  );

  blocTest(
    'submit, '
    'submit button is disabled, '
    'should do nothing',
    build: () => createBloc(
      gender: Gender.male,
      name: name,
      surname: surname,
      email: email,
      password: password,
    ),
    act: (bloc) => bloc.add(const SignUpEventSubmit()),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'should call auth service method to sign up and user repository method to add user with default settings, and should emit complete status with signed up info',
    build: () => createBloc(
      gender: Gender.male,
      name: name,
      surname: surname,
      email: email,
      password: password,
      passwordConfirmation: password,
    ),
    setUp: () {
      authService.mockSignUp(userId: 'u1');
      userRepository.mockAddUser();
    },
    act: (bloc) => bloc.add(const SignUpEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        gender: Gender.male,
        name: name,
        surname: surname,
        email: email,
        password: password,
        passwordConfirmation: password,
      ),
      createState(
        status: const BlocStatusComplete<SignUpBlocInfo>(
          info: SignUpBlocInfo.signedUp,
        ),
        gender: Gender.male,
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
        () => userRepository.addUser(
          user: createUser(
            id: 'u1',
            gender: Gender.male,
            name: name,
            surname: surname,
            settings: createSettings(
              themeMode: ThemeMode.system,
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
      gender: Gender.male,
      name: name,
      surname: surname,
      email: email,
      password: password,
      passwordConfirmation: password,
    ),
    setUp: () => authService.mockSignUp(
      throwable: const AuthException(
        code: AuthExceptionCode.emailAlreadyInUse,
      ),
    ),
    act: (bloc) => bloc.add(const SignUpEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        gender: Gender.male,
        name: name,
        surname: surname,
        email: email,
        password: password,
        passwordConfirmation: password,
      ),
      createState(
        status: const BlocStatusError<SignUpBlocError>(
          error: SignUpBlocError.emailAlreadyInUse,
        ),
        gender: Gender.male,
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
    build: () => createBloc(
      gender: Gender.male,
      name: name,
      surname: surname,
      email: email,
      password: password,
      passwordConfirmation: password,
    ),
    setUp: () => authService.mockSignUp(
      throwable: const NetworkException(
        code: NetworkExceptionCode.requestFailed,
      ),
    ),
    act: (bloc) => bloc.add(const SignUpEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        gender: Gender.male,
        name: name,
        surname: surname,
        email: email,
        password: password,
        passwordConfirmation: password,
      ),
      createState(
        status: const BlocStatusNetworkRequestFailed(),
        gender: Gender.male,
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
    build: () => createBloc(
      gender: Gender.male,
      name: name,
      surname: surname,
      email: email,
      password: password,
      passwordConfirmation: password,
    ),
    setUp: () => authService.mockSignUp(
      throwable: const UnknownException(
        message: 'unknown exception message',
      ),
    ),
    act: (bloc) => bloc.add(const SignUpEventSubmit()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        gender: Gender.male,
        name: name,
        surname: surname,
        email: email,
        password: password,
        passwordConfirmation: password,
      ),
      createState(
        status: const BlocStatusUnknownError(),
        gender: Gender.male,
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
