import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/model/settings.dart';
import '../../../domain/model/user.dart';
import '../../../domain/repository/user_repository.dart';
import '../../../domain/service/auth_service.dart';

class ThemeModeCubit extends Cubit<ThemeMode?> {
  final AuthService _authService;
  final UserRepository _userRepository;

  ThemeModeCubit({
    required AuthService authService,
    required UserRepository userRepository,
    ThemeMode? themeMode,
  })  : _authService = authService,
        _userRepository = userRepository,
        super(themeMode);

  Future<void> initialize() async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      return;
    }
    final User? user =
        await _userRepository.getUserById(userId: loggedUserId).first;
    emit(user?.settings.themeMode);
  }

  Future<void> updateThemeMode({
    required ThemeMode newThemeMode,
  }) async {
    ThemeMode? currentThemeMode, previousThemeMode;
    currentThemeMode = state;
    if (newThemeMode == currentThemeMode) {
      return;
    }
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      return;
    }
    emit(newThemeMode);
    previousThemeMode = currentThemeMode;
    currentThemeMode = newThemeMode;
    try {
      await _userRepository.updateUserSettings(
        userId: loggedUserId,
        themeMode: currentThemeMode,
      );
    } catch (_) {
      emit(previousThemeMode);
    }
  }
}
