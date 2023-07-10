import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../domain/additional_model/bloc_status.dart';
import '../../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../../domain/entity/settings.dart';
import '../../../../../domain/entity/user.dart';
import '../../../../../domain/repository/user_repository.dart';
import '../../../../../domain/service/auth_service.dart';
import '../../../additional_model/bloc_state.dart';

part 'profile_settings_event.dart';
part 'profile_settings_state.dart';

class ProfileSettingsBloc extends BlocWithStatus<ProfileSettingsEvent,
    ProfileSettingsState, dynamic, dynamic> {
  final AuthService _authService;
  final UserRepository _userRepository;
  StreamSubscription<User?>? _userListener;

  ProfileSettingsBloc({
    required AuthService authService,
    required UserRepository userRepository,
    ProfileSettingsState state = const ProfileSettingsState(
      status: BlocStatusInitial(),
    ),
  })  : _authService = authService,
        _userRepository = userRepository,
        super(state) {
    on<ProfileSettingsEventInitialize>(_initialize);
    on<ProfileSettingsEventUpdateThemeMode>(_updateThemeMode);
    on<ProfileSettingsEventUpdateLanguage>(_updateLanguage);
    on<ProfileSettingsEventUpdateDistanceUnit>(_updateDistanceUnit);
    on<ProfileSettingsEventUpdatePaceUnit>(_updatePaceUnit);
  }

  @override
  Future<void> close() {
    _userListener?.cancel();
    _userListener = null;
    return super.close();
  }

  Future<void> _initialize(
    ProfileSettingsEventInitialize event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    final Stream<User?> loggedUser$ =
        _authService.loggedUserId$.whereType<String>().switchMap(
              (String loggedUserId) => _userRepository.getUserById(
                userId: loggedUserId,
              ),
            );
    await for (final loggedUser in loggedUser$) {
      final Settings? settings = loggedUser?.settings;
      emit(state.copyWith(
        themeMode: settings?.themeMode,
        language: settings?.language,
        distanceUnit: settings?.distanceUnit,
        paceUnit: settings?.paceUnit,
      ));
    }
  }

  Future<void> _updateThemeMode(
    ProfileSettingsEventUpdateThemeMode event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    final ThemeMode? previousThemeMode = state.themeMode;
    if (event.newThemeMode == previousThemeMode) return;
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emit(state.copyWith(
      themeMode: event.newThemeMode,
    ));
    try {
      await _userRepository.updateUserSettings(
        userId: loggedUserId,
        themeMode: event.newThemeMode,
      );
    } catch (_) {
      emit(state.copyWith(
        themeMode: previousThemeMode,
      ));
    }
  }

  Future<void> _updateLanguage(
    ProfileSettingsEventUpdateLanguage event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    final Language? previousLanguage = state.language;
    if (event.newLanguage == previousLanguage) return;
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emit(state.copyWith(
      language: event.newLanguage,
    ));
    try {
      await _userRepository.updateUserSettings(
        userId: loggedUserId,
        language: event.newLanguage,
      );
    } catch (_) {
      emit(state.copyWith(
        language: previousLanguage,
      ));
    }
  }

  Future<void> _updateDistanceUnit(
    ProfileSettingsEventUpdateDistanceUnit event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    final DistanceUnit? previousDistanceUnit = state.distanceUnit;
    if (event.newDistanceUnit == previousDistanceUnit) return;
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emit(state.copyWith(
      distanceUnit: event.newDistanceUnit,
    ));
    try {
      await _userRepository.updateUserSettings(
        userId: loggedUserId,
        distanceUnit: event.newDistanceUnit,
      );
    } catch (_) {
      emit(state.copyWith(
        distanceUnit: previousDistanceUnit,
      ));
    }
  }

  Future<void> _updatePaceUnit(
    ProfileSettingsEventUpdatePaceUnit event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    final PaceUnit? previousPaceUnit = state.paceUnit;
    if (event.newPaceUnit == previousPaceUnit) return;
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emit(state.copyWith(
      paceUnit: event.newPaceUnit,
    ));
    try {
      await _userRepository.updateUserSettings(
        userId: loggedUserId,
        paceUnit: event.newPaceUnit,
      );
    } catch (_) {
      emit(state.copyWith(
        paceUnit: previousPaceUnit,
      ));
    }
  }
}
