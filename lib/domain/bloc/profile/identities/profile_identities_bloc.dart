import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../domain/additional_model/bloc_status.dart';
import '../../../../../domain/additional_model/bloc_with_status.dart';
import '../../../../../domain/entity/user.dart';
import '../../../../../domain/repository/user_repository.dart';
import '../../../../../domain/service/auth_service.dart';
import '../../../../dependency_injection.dart';
import '../../../additional_model/bloc_state.dart';
import '../../../additional_model/custom_exception.dart';
import '../../../repository/blood_test_repository.dart';
import '../../../repository/health_measurement_repository.dart';
import '../../../repository/race_repository.dart';
import '../../../repository/workout_repository.dart';

part 'profile_identities_event.dart';
part 'profile_identities_state.dart';

class ProfileIdentitiesBloc extends BlocWithStatus<
    ProfileIdentitiesEvent,
    ProfileIdentitiesState,
    ProfileIdentitiesBlocInfo,
    ProfileIdentitiesBlocError> {
  final AuthService _authService;
  final UserRepository _userRepository;
  final WorkoutRepository _workoutRepository;
  final HealthMeasurementRepository _healthMeasurementRepository;
  final BloodTestRepository _bloodTestRepository;
  final RaceRepository _raceRepository;

  ProfileIdentitiesBloc({
    ProfileIdentitiesState state = const ProfileIdentitiesState(
      status: BlocStatusInitial(),
    ),
  })  : _authService = getIt<AuthService>(),
        _userRepository = getIt<UserRepository>(),
        _workoutRepository = getIt<WorkoutRepository>(),
        _healthMeasurementRepository = getIt<HealthMeasurementRepository>(),
        _bloodTestRepository = getIt<BloodTestRepository>(),
        _raceRepository = getIt<RaceRepository>(),
        super(state) {
    on<ProfileIdentitiesEventInitialize>(
      _initialize,
      transformer: restartable(),
    );
    on<ProfileIdentitiesEventUpdateGender>(_updateGender);
    on<ProfileIdentitiesEventUpdateUsername>(_updateUsername);
    on<ProfileIdentitiesEventUpdateSurname>(_updateSurname);
    on<ProfileIdentitiesEventUpdateEmail>(_updateEmail);
    on<ProfileIdentitiesEventUpdatePassword>(_updatePassword);
    on<ProfileIdentitiesEventDeleteAccount>(_deleteAccount);
  }

  Future<void> _initialize(
    ProfileIdentitiesEventInitialize event,
    Emitter<ProfileIdentitiesState> emit,
  ) async {
    final Stream<(String?, User?)> userIdentities$ = Rx.combineLatest2(
      _authService.loggedUserEmail$,
      _loggedUserData$,
      (String? loggedUserEmail, User? loggedUserData) =>
          (loggedUserEmail, loggedUserData),
    );
    await emit.forEach(
      userIdentities$,
      onData: ((String?, User?) identities) {
        final String? loggedUserEmail = identities.$1;
        final User? loggedUserData = identities.$2;
        return state.copyWith(
          gender: loggedUserData?.gender,
          email: loggedUserEmail,
          username: loggedUserData?.name,
          surname: loggedUserData?.surname,
        );
      },
    );
  }

  Future<void> _updateGender(
    ProfileIdentitiesEventUpdateGender event,
    Emitter<ProfileIdentitiesState> emit,
  ) async {
    final Gender? previousGender = state.gender;
    if (event.gender == previousGender) return;
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emit(state.copyWith(
      gender: event.gender,
    ));
    try {
      await _userRepository.updateUserIdentities(
        userId: loggedUserId,
        gender: event.gender,
      );
    } catch (_) {
      emit(state.copyWith(
        gender: previousGender,
      ));
    }
  }

  Future<void> _updateUsername(
    ProfileIdentitiesEventUpdateUsername event,
    Emitter<ProfileIdentitiesState> emit,
  ) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
    await _userRepository.updateUserIdentities(
      userId: loggedUserId,
      name: event.username,
    );
    emitCompleteStatus(emit, ProfileIdentitiesBlocInfo.dataSaved);
  }

  Future<void> _updateSurname(
    ProfileIdentitiesEventUpdateSurname event,
    Emitter<ProfileIdentitiesState> emit,
  ) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
    await _userRepository.updateUserIdentities(
      userId: loggedUserId,
      surname: event.surname,
    );
    emitCompleteStatus(emit, ProfileIdentitiesBlocInfo.dataSaved);
  }

  Future<void> _updateEmail(
    ProfileIdentitiesEventUpdateEmail event,
    Emitter<ProfileIdentitiesState> emit,
  ) async {
    emitLoadingStatus(emit);
    try {
      await _authService.updateEmail(newEmail: event.newEmail);
      emitCompleteStatus(emit, ProfileIdentitiesBlocInfo.dataSaved);
    } on AuthException catch (authException) {
      final ProfileIdentitiesBlocError? error =
          _mapAuthExceptionCodeToBlocError(authException.code);
      if (error != null) {
        emitErrorStatus(emit, error);
      } else {
        emitUnknownErrorStatus(emit);
        rethrow;
      }
    } on NetworkException catch (networkException) {
      if (networkException.code == NetworkExceptionCode.requestFailed) {
        emitNetworkRequestFailed(emit);
      }
    } on UnknownException catch (unknownException) {
      emitUnknownErrorStatus(emit);
      throw unknownException.message;
    }
  }

  Future<void> _updatePassword(
    ProfileIdentitiesEventUpdatePassword event,
    Emitter<ProfileIdentitiesState> emit,
  ) async {
    emitLoadingStatus(emit);
    try {
      await _authService.updatePassword(newPassword: event.newPassword);
      emitCompleteStatus(emit, ProfileIdentitiesBlocInfo.dataSaved);
    } on NetworkException catch (networkException) {
      if (networkException.code == NetworkExceptionCode.requestFailed) {
        emitNetworkRequestFailed(emit);
      }
    } on UnknownException catch (unknownException) {
      emitUnknownErrorStatus(emit);
      throw unknownException.message;
    }
  }

  Future<void> _deleteAccount(
    ProfileIdentitiesEventDeleteAccount event,
    Emitter<ProfileIdentitiesState> emit,
  ) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
    try {
      await _deleteAllLoggedUserData(loggedUserId);
      await _authService.deleteAccount();
      emitCompleteStatus(emit, ProfileIdentitiesBlocInfo.accountDeleted);
    } on NetworkException catch (networkException) {
      if (networkException.code == NetworkExceptionCode.requestFailed) {
        emitNetworkRequestFailed(emit);
      }
    } on UnknownException catch (unknownException) {
      emitUnknownErrorStatus(emit);
      throw unknownException.message;
    }
  }

  Stream<User?> get _loggedUserData$ {
    return _authService.loggedUserId$.whereNotNull().switchMap(
          (String userId) => _userRepository.getUserById(userId: userId),
        );
  }

  ProfileIdentitiesBlocError? _mapAuthExceptionCodeToBlocError(
    AuthExceptionCode authExceptionCode,
  ) {
    if (authExceptionCode == AuthExceptionCode.emailAlreadyInUse) {
      return ProfileIdentitiesBlocError.emailAlreadyInUse;
    }
    return null;
  }

  Future<void> _deleteAllLoggedUserData(String loggedUserId) async {
    await _workoutRepository.deleteAllUserWorkouts(userId: loggedUserId);
    await _healthMeasurementRepository.deleteAllUserMeasurements(
      userId: loggedUserId,
    );
    await _bloodTestRepository.deleteAllUserTests(userId: loggedUserId);
    await _raceRepository.deleteAllUserRaces(userId: loggedUserId);
    await _userRepository.deleteUser(userId: loggedUserId);
  }
}

enum ProfileIdentitiesBlocInfo { dataSaved, accountDeleted }

enum ProfileIdentitiesBlocError { emailAlreadyInUse }
