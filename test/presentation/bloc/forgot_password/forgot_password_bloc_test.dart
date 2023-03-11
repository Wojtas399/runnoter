import 'package:bloc_test/bloc_test.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:runnoter/presentation/screen/forgot_password/bloc/forgot_password_event.dart';
import 'package:runnoter/presentation/screen/forgot_password/bloc/forgot_password_state.dart';

void main() {
  ForgotPasswordBloc createBloc({
    String email = '',
  }) {
    return ForgotPasswordBloc(
      email: email,
    );
  }

  ForgotPasswordState createState({
    BlocStatus status = const BlocStatusInitial(),
    String email = '',
  }) {
    return ForgotPasswordState(
      status: status,
      email: email,
    );
  }

  blocTest(
    'email changed, should update email in state',
    build: () => createBloc(),
    act: (ForgotPasswordBloc bloc) {
      bloc.add(
        const ForgotPasswordEventEmailChanged(
          email: 'email@example.com',
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        email: 'email@example.com',
      ),
    ],
  );

  //TODO: tests for submit event
}
