import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/additional_model/auth_exception.dart';
import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../domain/entity/user.dart';
import '../../../../domain/repository/user_repository.dart';
import '../../../../domain/service/auth_service.dart';
import 'profile_identities_event.dart';
import 'profile_identities_state.dart';

class ProfileIdentitiesBloc extends BlocWithStatus<ProfileIdentitiesEvent,
    ProfileIdentitiesState, ProfileInfo, ProfileError> {
  final AuthService _authService;
  final UserRepository _userRepository;
  StreamSubscription<String?>? _emailListener;
  StreamSubscription<User?>? _userDataListener;

  ProfileIdentitiesBloc({
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
          ProfileIdentitiesState(
            status: status,
            userId: userId,
            username: username,
            surname: surname,
            email: email,
          ),
        ) {
    on<ProfileIdentitiesEventInitialize>(_initialize);
    on<ProfileIdentitiesEventEmailUpdated>(_emailUpdated);
    on<ProfileIdentitiesEventUserUpdated>(_userUpdated);
    on<ProfileIdentitiesEventUpdateUsername>(_updateUsername);
    on<ProfileIdentitiesEventUpdateSurname>(_updateSurname);
    on<ProfileIdentitiesEventUpdateEmail>(_updateEmail);
    on<ProfileIdentitiesEventUpdatePassword>(_updatePassword);
    on<ProfileIdentitiesEventDeleteAccount>(_deleteAccount);
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
    ProfileIdentitiesEventInitialize event,
    Emitter<ProfileIdentitiesState> emit,
  ) {
    _setEmailListener();
    _setUserDataListener();
  }

  void _emailUpdated(
    ProfileIdentitiesEventEmailUpdated event,
    Emitter<ProfileIdentitiesState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
    ));
  }

  void _userUpdated(
    ProfileIdentitiesEventUserUpdated event,
    Emitter<ProfileIdentitiesState> emit,
  ) {
    emit(state.copyWith(
      userId: event.user?.id,
      username: event.user?.name,
      surname: event.user?.surname,
    ));
  }

  Future<void> _updateUsername(
    ProfileIdentitiesEventUpdateUsername event,
    Emitter<ProfileIdentitiesState> emit,
  ) async {
    final String? userId = state.userId;
    if (userId == null) {
      return;
    }
    emitLoadingStatus(emit);
    await _userRepository.updateUserIdentities(
      userId: userId,
      name: event.username,
    );
    emitCompleteStatus(emit, ProfileInfo.savedData);
  }

  Future<void> _updateSurname(
    ProfileIdentitiesEventUpdateSurname event,
    Emitter<ProfileIdentitiesState> emit,
  ) async {
    final String? userId = state.userId;
    if (userId == null) {
      return;
    }
    emitLoadingStatus(emit);
    await _userRepository.updateUserIdentities(
      userId: userId,
      surname: event.surname,
    );
    emitCompleteStatus(emit, ProfileInfo.savedData);
  }

  Future<void> _updateEmail(
    ProfileIdentitiesEventUpdateEmail event,
    Emitter<ProfileIdentitiesState> emit,
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
    ProfileIdentitiesEventUpdatePassword event,
    Emitter<ProfileIdentitiesState> emit,
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
    ProfileIdentitiesEventDeleteAccount event,
    Emitter<ProfileIdentitiesState> emit,
  ) async {
    final String? userId = state.userId;
    if (userId == null) {
      return;
    }
    emitLoadingStatus(emit);
    try {
      final bool isPasswordCorrect = await _authService.isPasswordCorrect(
        password: event.password,
      );
      if (!isPasswordCorrect) {
        emitErrorStatus(emit, ProfileError.wrongPassword);
        return;
      }
      await _userRepository.deleteUser(
        userId: userId,
      );
      await _authService.deleteAccount(
        password: event.password,
      );
      emitCompleteStatus(emit, ProfileInfo.accountDeleted);
    } catch (_) {
      emitUnknownErrorStatus(emit);
      rethrow;
    }
  }

  void _setEmailListener() {
    _emailListener ??= _authService.loggedUserEmail$.listen(
      (String? email) {
        add(
          ProfileIdentitiesEventEmailUpdated(
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
          ProfileIdentitiesEventUserUpdated(
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
