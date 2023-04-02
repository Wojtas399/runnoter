import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/model/settings.dart';
import '../../../../domain/model/user.dart';
import '../../../../domain/repository/user_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';
import 'profile_settings_event.dart';
import 'profile_settings_state.dart';

class ProfileSettingsBloc extends BlocWithStatus<ProfileSettingsEvent,
    ProfileSettingsState, dynamic, dynamic> {
  final AuthService _authService;
  final UserRepository _userRepository;
  StreamSubscription<User?>? _userListener;

  ProfileSettingsBloc({
    required AuthService authService,
    required UserRepository userRepository,
    BlocStatus status = const BlocStatusInitial(),
    ThemeMode? themeMode,
    Language? language,
    DistanceUnit? distanceUnit,
    PaceUnit? paceUnit,
  })  : _authService = authService,
        _userRepository = userRepository,
        super(
          ProfileSettingsState(
            status: status,
            themeMode: themeMode,
            language: language,
            distanceUnit: distanceUnit,
            paceUnit: paceUnit,
          ),
        ) {
    on<ProfileSettingsEventInitialize>(_initialize);
    on<ProfileSettingsEventUserUpdated>(_userUpdated);
  }

  @override
  Future<void> close() {
    _userListener?.cancel();
    _userListener = null;
    return super.close();
  }

  void _initialize(
    ProfileSettingsEventInitialize event,
    Emitter<ProfileSettingsState> emit,
  ) {
    _userListener ??= _authService.loggedUserId$
        .whereType<String>()
        .switchMap(
          (String userId) => _userRepository.getUserById(userId: userId),
        )
        .listen(
      (User? user) {
        add(
          ProfileSettingsEventUserUpdated(user: user),
        );
      },
    );
  }

  void _userUpdated(
    ProfileSettingsEventUserUpdated event,
    Emitter<ProfileSettingsState> emit,
  ) {
    final Settings? settings = event.user?.settings;
    emit(state.copyWith(
      themeMode: settings?.themeMode,
      language: settings?.language,
      distanceUnit: settings?.distanceUnit,
      paceUnit: settings?.paceUnit,
    ));
  }
}
