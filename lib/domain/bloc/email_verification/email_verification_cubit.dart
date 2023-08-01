import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../service/auth_service.dart';

class EmailVerificationCubit extends Cubit<String?> {
  final AuthService _authService;

  EmailVerificationCubit()
      : _authService = getIt<AuthService>(),
        super(null);

  Future<void> initialize() async {
    final String? loggedUserEmail = await _authService.loggedUserEmail$.first;
    emit(loggedUserEmail);
  }

  Future<void> resendEmailVerification() async {
    await _authService.sendEmailVerification();
  }
}
