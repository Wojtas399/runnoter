import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../domain/additional_model/auth_exception.dart';
import '../../../../../domain/additional_model/bloc_status.dart';
import '../../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../../domain/entity/user.dart';
import '../../../../../domain/repository/user_repository.dart';
import '../../../../../domain/service/auth_service.dart';
import '../../../additional_model/bloc_state.dart';
import '../../../repository/blood_test_repository.dart';
import '../../../repository/competition_repository.dart';
import '../../../repository/health_measurement_repository.dart';
import '../../../repository/workout_repository.dart';

part 'profile_identities_event.dart';
part 'profile_identities_state.dart';

class ProfileIdentitiesBloc extends BlocWithStatus<ProfileIdentitiesEvent,
    ProfileIdentitiesState, ProfileInfo, ProfileError> {
  final AuthService _authService;
  final UserRepository _userRepository;
  final WorkoutRepository _workoutRepository;
  final HealthMeasurementRepository _healthMeasurementRepository;
  final BloodTestRepository _bloodTestRepository;
  final CompetitionRepository _competitionRepository;
  StreamSubscription<(String?, User?)>? _userIdentitiesListener;

  ProfileIdentitiesBloc({
    required AuthService authService,
    required UserRepository userRepository,
    required WorkoutRepository workoutRepository,
    required HealthMeasurementRepository healthMeasurementRepository,
    required BloodTestRepository bloodTestRepository,
    required CompetitionRepository competitionRepository,
    ProfileIdentitiesState state = const ProfileIdentitiesState(
      status: BlocStatusInitial(),
    ),
  })  : _authService = authService,
        _userRepository = userRepository,
        _workoutRepository = workoutRepository,
        _healthMeasurementRepository = healthMeasurementRepository,
        _bloodTestRepository = bloodTestRepository,
        _competitionRepository = competitionRepository,
        super(state) {
    on<ProfileIdentitiesEventInitialize>(_initialize);
    on<ProfileIdentitiesEventIdentitiesUpdated>(_identitiesUpdated);
    on<ProfileIdentitiesEventUpdateUsername>(_updateUsername);
    on<ProfileIdentitiesEventUpdateSurname>(_updateSurname);
    on<ProfileIdentitiesEventUpdateEmail>(_updateEmail);
    on<ProfileIdentitiesEventUpdatePassword>(_updatePassword);
    on<ProfileIdentitiesEventDeleteAccount>(_deleteAccount);
  }

  @override
  Future<void> close() {
    _userIdentitiesListener?.cancel();
    _userIdentitiesListener = null;
    return super.close();
  }

  void _initialize(
    ProfileIdentitiesEventInitialize event,
    Emitter<ProfileIdentitiesState> emit,
  ) {
    _setLoggedUserIdentitiesListener();
  }

  void _identitiesUpdated(
    ProfileIdentitiesEventIdentitiesUpdated event,
    Emitter<ProfileIdentitiesState> emit,
  ) {
    emit(state.copyWith(
      loggedUserId: event.user?.id,
      email: event.email,
      username: event.user?.name,
      surname: event.user?.surname,
    ));
  }

  Future<void> _updateUsername(
    ProfileIdentitiesEventUpdateUsername event,
    Emitter<ProfileIdentitiesState> emit,
  ) async {
    final String? userId = state.loggedUserId;
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
    final String? userId = state.loggedUserId;
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
    if (state.loggedUserId == null) {
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
      await _deleteAllLoggedUserData();
      await _authService.deleteAccount(
        password: event.password,
      );
      emitCompleteStatus(emit, ProfileInfo.accountDeleted);
    } catch (_) {
      emitUnknownErrorStatus(emit);
      rethrow;
    }
  }

  void _setLoggedUserIdentitiesListener() {
    _userIdentitiesListener ??= Rx.combineLatest2(
      _authService.loggedUserEmail$,
      _loggedUserData$,
      (
        String? loggedUserEmail,
        User? loggedUserData,
      ) =>
          (loggedUserEmail, loggedUserData),
    ).listen(
      ((String?, User?) listenedParams) => add(
        ProfileIdentitiesEventIdentitiesUpdated(
          email: listenedParams.$1,
          user: listenedParams.$2,
        ),
      ),
    );
  }

  Stream<User?> get _loggedUserData$ {
    return _authService.loggedUserId$.whereType<String>().switchMap(
          (String userId) => _userRepository.getUserById(
            userId: userId,
          ),
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

  Future<void> _deleteAllLoggedUserData() async {
    await _workoutRepository.deleteAllUserWorkouts(userId: state.loggedUserId!);
    await _healthMeasurementRepository.deleteAllUserMeasurements(
      userId: state.loggedUserId!,
    );
    await _bloodTestRepository.deleteAllUserTests(userId: state.loggedUserId!);
    await _competitionRepository.deleteAllUserCompetitions(
      userId: state.loggedUserId!,
    );
    await _userRepository.deleteUser(userId: state.loggedUserId!);
  }
}
