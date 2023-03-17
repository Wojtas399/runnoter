import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/auth_exception.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/sign_up/bloc/sign_up_bloc.dart';
import 'package:runnoter/presentation/screen/sign_up/bloc/sign_up_event.dart';
import 'package:runnoter/presentation/screen/sign_up/bloc/sign_up_state.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/presentation/service/mock_connectivity_service.dart';

void main() {
  final authService = MockAuthService();
  final connectivityService = MockConnectivityService();
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
      connectivityService: connectivityService,
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
    reset(connectivityService);
  });

  blocTest(
    'name changed, '
    'should update username in state',
    build: () => createBloc(),
    act: (SignUpBloc bloc) {
      bloc.add(
        const SignUpEventNameChanged(
          name: name,
        ),
      );
    },
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
    act: (SignUpBloc bloc) {
      bloc.add(
        const SignUpEventSurnameChanged(
          surname: surname,
        ),
      );
    },
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
    act: (SignUpBloc bloc) {
      bloc.add(
        const SignUpEventEmailChanged(
          email: email,
        ),
      );
    },
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
    act: (SignUpBloc bloc) {
      bloc.add(
        const SignUpEventPasswordChanged(
          password: password,
        ),
      );
    },
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
    act: (SignUpBloc bloc) {
      bloc.add(
        const SignUpEventPasswordConfirmationChanged(
          passwordConfirmation: password,
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        passwordConfirmation: password,
      ),
    ],
  );

  blocTest(
    'submit, '
    'should call auth service method to sign up and should emit complete status with signed up info',
    build: () => createBloc(
      name: name,
      surname: surname,
      email: email,
      password: password,
    ),
    setUp: () {
      connectivityService.mockHasDeviceInternetConnection(
        hasConnection: true,
      );
      authService.mockSignUp();
    },
    act: (SignUpBloc bloc) {
      bloc.add(
        const SignUpEventSubmit(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        name: name,
        surname: surname,
        email: email,
        password: password,
      ),
      createState(
        status: const BlocStatusComplete<SignUpInfo>(
          info: SignUpInfo.signedUp,
        ),
        name: name,
        surname: surname,
        email: email,
        password: password,
      ),
    ],
    verify: (_) {
      verify(
        () => connectivityService.hasDeviceInternetConnection(),
      ).called(1);
      verify(
        () => authService.signUp(
          name: name,
          surname: surname,
          email: email,
          password: password,
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'device does not have internet connection, '
    'should emit no internet connection status',
    build: () => createBloc(
      name: name,
      surname: surname,
      email: email,
      password: password,
    ),
    setUp: () {
      connectivityService.mockHasDeviceInternetConnection(
        hasConnection: false,
      );
    },
    act: (SignUpBloc bloc) {
      bloc.add(
        const SignUpEventSubmit(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        name: name,
        surname: surname,
        email: email,
        password: password,
      ),
      createState(
        status: const BlocStatusNoInternetConnection(),
        name: name,
        surname: surname,
        email: email,
        password: password,
      ),
    ],
    verify: (_) {
      verify(
        () => connectivityService.hasDeviceInternetConnection(),
      ).called(1);
      verifyNever(
        () => authService.signUp(
          name: any(named: 'name'),
          surname: any(named: 'surname'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    },
  );

  blocTest(
    'submit, '
    'auth service method throws email already in use exception, '
    'should emit error status with email already in use error',
    build: () => createBloc(
      name: name,
      surname: surname,
      email: email,
      password: password,
    ),
    setUp: () {
      connectivityService.mockHasDeviceInternetConnection(
        hasConnection: true,
      );
      authService.mockSignUp(
        throwable: AuthException.emailAlreadyInUse,
      );
    },
    act: (SignUpBloc bloc) {
      bloc.add(
        const SignUpEventSubmit(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        name: name,
        surname: surname,
        email: email,
        password: password,
      ),
      createState(
        status: const BlocStatusError<SignUpError>(
          error: SignUpError.emailAlreadyInUse,
        ),
        name: name,
        surname: surname,
        email: email,
        password: password,
      ),
    ],
    verify: (_) {
      verify(
        () => connectivityService.hasDeviceInternetConnection(),
      ).called(1);
      verify(
        () => authService.signUp(
          name: name,
          surname: surname,
          email: email,
          password: password,
        ),
      ).called(1);
    },
  );

  blocTest(
    'submit, '
    'auth service method throws unknown error, '
    'should emit error status with unknown error and should rethrow error',
    build: () => createBloc(
      name: name,
      surname: surname,
      email: email,
      password: password,
    ),
    setUp: () {
      connectivityService.mockHasDeviceInternetConnection(
        hasConnection: true,
      );
      authService.mockSignUp(
        throwable: 'Unknown error...',
      );
    },
    act: (SignUpBloc bloc) {
      bloc.add(
        const SignUpEventSubmit(),
      );
    },
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
    errors: () => ['Unknown error...'],
    verify: (_) {
      verify(
        () => connectivityService.hasDeviceInternetConnection(),
      ).called(1);
      verify(
        () => authService.signUp(
          name: name,
          surname: surname,
          email: email,
          password: password,
        ),
      ).called(1);
    },
  );
}
