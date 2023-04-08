import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/model/settings.dart';
import '../../../domain/model/user.dart';
import '../../../domain/repository/user_repository.dart';
import '../../../domain/service/auth_service.dart';

class LanguageCubit extends Cubit<Language?> {
  final AuthService _authService;
  final UserRepository _userRepository;

  LanguageCubit({
    required AuthService authService,
    required UserRepository userRepository,
    Language? language,
  })  : _authService = authService,
        _userRepository = userRepository,
        super(language);

  Future<void> initialize() async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      return;
    }
    final User? user =
        await _userRepository.getUserById(userId: loggedUserId).first;
    emit(user?.settings.language);
  }

  Future<void> updateLanguage({
    required Language newLanguage,
  }) async {
    Language? currentLanguage, previousLanguage;
    currentLanguage = state;
    if (newLanguage == currentLanguage) {
      return;
    }
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      return;
    }
    emit(newLanguage);
    previousLanguage = currentLanguage;
    currentLanguage = newLanguage;
    try {
      await _userRepository.updateUserSettings(
        userId: loggedUserId,
        language: currentLanguage,
      );
    } catch (exception) {
      emit(previousLanguage);
    }
  }
}
