import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/model/auth_exception.dart';
import '../../../../domain/model/user.dart';
import '../../../../domain/repository/user_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends BlocWithStatus<ProfileEvent, ProfileState,
    ProfileInfo, ProfileError> {
  final AuthService _authService;
  final UserRepository _userRepository;
  StreamSubscription<String?>? _emailListener;
  StreamSubscription<User?>? _userDataListener;

  ProfileBloc({
    required AuthService authService,
    required UserRepository userRepository,
    BlocStatus status = const BlocStatusInitial(),
    String? userId,
    String? username,
    String? surname,
    String? email,
  })  : _authService = authService,
        _userRepository = userRepository,
        super(
          ProfileState(
            status: status,
            userId: userId,
            username: username,
            surname: surname,
            email: email,
          ),
        ) {
    on<ProfileEventInitialize>(_initialize);
    on<ProfileEventEmailUpdated>(_emailUpdated);
    on<ProfileEventUserUpdated>(_userUpdated);
    on<ProfileEventUpdateUsername>(_updateUsername);
    on<ProfileEventUpdateSurname>(_updateSurname);
    on<ProfileEventUpdateEmail>(_updateEmail);
    on<ProfileEventUpdatePassword>(_updatePassword);
    on<ProfileEventDeleteAccount>(_deleteAccount);
  }

  @override
  Future<void> close() {
    _emailListener?.cancel();
    _emailListener = null;
    _userDataListener?.cancel();
    _userDataListener = null;
    return super.close();
  }

  void _initialize(
    ProfileEventInitialize event,
    Emitter<ProfileState> emit,
  ) {
    _setEmailListener();
    _setUserDataListener();
  }

  void _emailUpdated(
    ProfileEventEmailUpdated event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
    ));
  }

  void _userUpdated(
    ProfileEventUserUpdated event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(
      userId: event.user?.id,
      username: event.user?.name,
      surname: event.user?.surname,
    ));
  }

  Future<void> _updateUsername(
    ProfileEventUpdateUsername event,
    Emitter<ProfileState> emit,
  ) async {
    final String? userId = state.userId;
    if (userId == null) {
      return;
    }
    emitLoadingStatus(emit);
    await _userRepository.updateUser(
      userId: userId,
      name: event.username,
    );
    emitCompleteStatus(emit, ProfileInfo.savedData);
  }

  Future<void> _updateSurname(
    ProfileEventUpdateSurname event,
    Emitter<ProfileState> emit,
  ) async {
    final String? userId = state.userId;
    if (userId == null) {
      return;
    }
    emitLoadingStatus(emit);
    await _userRepository.updateUser(
      userId: userId,
      surname: event.surname,
    );
    emitCompleteStatus(emit, ProfileInfo.savedData);
  }

  Future<void> _updateEmail(
    ProfileEventUpdateEmail event,
    Emitter<ProfileState> emit,
  ) async {
    emitLoadingStatus(emit);
    try {
      await _authService.updateEmail(
        newEmail: event.newEmail,
        password: event.password,
      );
      emitCompleteStatus(emit, ProfileInfo.savedData);
    } on AuthException catch (authException) {
      final ProfileError? error = _mapAuthExceptionToBlocError(authException);
      if (error != null) {
        emitErrorStatus(emit, error);
      } else {
        emitUnknownErrorStatus(emit);
        rethrow;
      }
    } catch (_) {
      emitUnknownErrorStatus(emit);
      rethrow;
    }
  }

  Future<void> _updatePassword(
    ProfileEventUpdatePassword event,
    Emitter<ProfileState> emit,
  ) async {
    emitLoadingStatus(emit);
    try {
      await _authService.updatePassword(
        newPassword: event.newPassword,
        currentPassword: event.currentPassword,
      );
      emitCompleteStatus(emit, ProfileInfo.savedData);
    } on AuthException catch (authException) {
      if (authException == AuthException.wrongPassword) {
        emitErrorStatus(emit, ProfileError.wrongCurrentPassword);
      } else {
        emitUnknownErrorStatus(emit);
        rethrow;
      }
    } catch (_) {
      emitUnknownErrorStatus(emit);
      rethrow;
    }
  }

  Future<void> _deleteAccount(
    ProfileEventDeleteAccount event,
    Emitter<ProfileState> emit,
  ) async {
    emitLoadingStatus(emit);
    try {
      await _authService.deleteAccount(
        password: event.password,
      );
      emitCompleteStatus(emit, ProfileInfo.accountDeleted);
    } on AuthException catch (authException) {
      final ProfileError? error = _mapAuthExceptionToBlocError(
        authException,
      );
      if (error != null) {
        emitErrorStatus(emit, error);
      } else {
        emitUnknownErrorStatus(emit);
        rethrow;
      }
    } catch (_) {
      emitUnknownErrorStatus(emit);
      rethrow;
    }
  }

  void _setEmailListener() {
    _emailListener ??= _authService.loggedUserEmail$.listen(
      (String? email) {
        add(
          ProfileEventEmailUpdated(
            email: email,
          ),
        );
      },
    );
  }

  void _setUserDataListener() {
    _userDataListener ??= _authService.loggedUserId$
        .whereType<String>()
        .switchMap(
          (String userId) => _userRepository.getUserById(
            userId: userId,
          ),
        )
        .listen(
      (User? user) {
        add(
          ProfileEventUserUpdated(
            user: user,
          ),
        );
      },
    );
  }

  ProfileError? _mapAuthExceptionToBlocError(AuthException exception) {
    if (exception == AuthException.wrongPassword) {
      return ProfileError.wrongPassword;
    } else if (exception == AuthException.emailAlreadyInUse) {
      return ProfileError.emailAlreadyInUse;
    }
    return null;
  }
}
