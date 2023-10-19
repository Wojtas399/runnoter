import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../dependency_injection.dart';
import '../../../../data/model/user.dart';
import '../../../../data/repository/user/user_repository.dart';
import '../../../../data/service/auth/auth_service.dart';

part 'profile_settings_state.dart';

class ProfileSettingsCubit extends Cubit<ProfileSettingsState> {
  final AuthService _authService;
  final UserRepository _userRepository;
  StreamSubscription<UserSettings?>? _userSettingsListener;

  ProfileSettingsCubit({
    ProfileSettingsState initialState = const ProfileSettingsState(),
  })  : _authService = getIt<AuthService>(),
        _userRepository = getIt<UserRepository>(),
        super(initialState);

  @override
  Future<void> close() {
    _userSettingsListener?.cancel();
    _userSettingsListener = null;
    return super.close();
  }

  Future<void> initialize() async {
    _userSettingsListener ??= _authService.loggedUserId$
        .whereNotNull()
        .switchMap(
          (loggedUserId) => _userRepository.getUserById(userId: loggedUserId),
        )
        .map((User? user) => user?.settings)
        .listen(
          (UserSettings? userSettings) => emit(state.copyWith(
            themeMode: userSettings?.themeMode,
            language: userSettings?.language,
            distanceUnit: userSettings?.distanceUnit,
            paceUnit: userSettings?.paceUnit,
          )),
        );
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    final ThemeMode? previousThemeMode = state.themeMode;
    if (newThemeMode == previousThemeMode) return;
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) return;
    emit(state.copyWith(themeMode: newThemeMode));
    try {
      await _userRepository.updateUserSettings(
        userId: loggedUserId,
        themeMode: newThemeMode,
      );
    } catch (_) {
      emit(state.copyWith(themeMode: previousThemeMode));
    }
  }

  Future<void> updateLanguage(Language? newLanguage) async {
    final Language? previousLanguage = state.language;
    if (newLanguage == previousLanguage) return;
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) return;
    emit(state.copyWith(language: newLanguage));
    try {
      await _userRepository.updateUserSettings(
        userId: loggedUserId,
        language: newLanguage,
      );
    } catch (_) {
      emit(state.copyWith(language: previousLanguage));
    }
  }

  Future<void> updateDistanceUnit(DistanceUnit? newDistanceUnit) async {
    final DistanceUnit? previousDistanceUnit = state.distanceUnit;
    if (newDistanceUnit == previousDistanceUnit) return;
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) return;
    emit(state.copyWith(distanceUnit: newDistanceUnit));
    try {
      await _userRepository.updateUserSettings(
        userId: loggedUserId,
        distanceUnit: newDistanceUnit,
      );
    } catch (_) {
      emit(state.copyWith(distanceUnit: previousDistanceUnit));
    }
  }

  Future<void> updatePaceUnit(PaceUnit? newPaceUnit) async {
    final PaceUnit? previousPaceUnit = state.paceUnit;
    if (newPaceUnit == previousPaceUnit) return;
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) return;
    emit(state.copyWith(paceUnit: newPaceUnit));
    try {
      await _userRepository.updateUserSettings(
        userId: loggedUserId,
        paceUnit: newPaceUnit,
      );
    } catch (_) {
      emit(state.copyWith(paceUnit: previousPaceUnit));
    }
  }
}
