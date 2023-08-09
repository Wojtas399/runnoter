import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dependency_injection.dart';
import '../additional_model/custom_exception.dart';
import '../service/auth_service.dart';

class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  final AuthService _authService;

  EmailVerificationCubit({
    EmailVerificationState state = const EmailVerificationStateInitial(),
  })  : _authService = getIt<AuthService>(),
        super(state);

  Future<void> initialize() async {
    final String? loggedUserEmail = await _authService.loggedUserEmail$.first;
    emit(EmailVerificationStateComplete(email: loggedUserEmail));
  }

  Future<void> resendEmailVerification() async {
    if (state is EmailVerificationStateLoading) return;
    emit(EmailVerificationStateLoading(email: state.email));
    try {
      await _authService.sendEmailVerification();
      emit(EmailVerificationStateComplete(email: state.email));
    } on NetworkException catch (exception) {
      if (exception.code == NetworkExceptionCode.tooManyRequests) {
        emit(EmailVerificationStateTooManyRequests(email: state.email));
      }
    }
  }
}

abstract class EmailVerificationState extends Equatable {
  final String? email;

  const EmailVerificationState({this.email});

  @override
  List<Object?> get props => [email];
}

class EmailVerificationStateInitial extends EmailVerificationState {
  const EmailVerificationStateInitial({super.email});
}

class EmailVerificationStateLoading extends EmailVerificationState {
  const EmailVerificationStateLoading({super.email});
}

class EmailVerificationStateComplete extends EmailVerificationState {
  const EmailVerificationStateComplete({super.email});
}

class EmailVerificationStateTooManyRequests extends EmailVerificationState {
  const EmailVerificationStateTooManyRequests({super.email});
}
