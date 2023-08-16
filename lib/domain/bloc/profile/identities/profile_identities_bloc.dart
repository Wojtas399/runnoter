import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
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
import '../../../repository/person_repository.dart';
import '../../../repository/race_repository.dart';
import '../../../repository/workout_repository.dart';
import '../../../service/coaching_request_service.dart';

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
  final CoachingRequestService _coachingRequestService;
  final PersonRepository _personRepository;

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
        _coachingRequestService = getIt<CoachingRequestService>(),
        _personRepository = getIt<PersonRepository>(),
        super(state) {
    on<ProfileIdentitiesEventInitialize>(
      _initialize,
      transformer: restartable(),
    );
    on<ProfileIdentitiesEventUpdateGender>(_updateGender);
    on<ProfileIdentitiesEventUpdateUsername>(_updateUsername);
    on<ProfileIdentitiesEventUpdateSurname>(_updateSurname);
    on<ProfileIdentitiesEventUpdateEmail>(_updateEmail);
    on<ProfileIdentitiesEventSendEmailVerification>(_sendEmailVerification);
    on<ProfileIdentitiesEventUpdatePassword>(_updatePassword);
    on<ProfileIdentitiesEventDeleteAccount>(_deleteAccount);
    on<ProfileIdentitiesEventReloadLoggedUser>(_reloadLoggedUser);
  }

  Future<void> _initialize(
    ProfileIdentitiesEventInitialize event,
    Emitter<ProfileIdentitiesState> emit,
  ) async {
    final Stream<ProfileIdentitiesBlocListenedParams> stream$ =
        Rx.combineLatest3(
      _authService.loggedUserEmail$,
      _authService.hasLoggedUserVerifiedEmail$,
      _loggedUserData$,
      (
        String? loggedUserEmail,
        bool? hasLoggedUserVerifiedEmail,
        User? loggedUserData,
      ) =>
          ProfileIdentitiesBlocListenedParams(
        loggedUserEmail: loggedUserEmail,
        isEmailVerified: hasLoggedUserVerifiedEmail,
        loggedUserData: loggedUserData,
      ),
    );
    await emit.forEach(
      stream$,
      onData: (ProfileIdentitiesBlocListenedParams params) => state.copyWith(
        accountType: params.loggedUserData?.accountType,
        gender: params.loggedUserData?.gender,
        username: params.loggedUserData?.name,
        surname: params.loggedUserData?.surname,
        email: params.loggedUserEmail,
        isEmailVerified: params.isEmailVerified,
      ),
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
      await _userRepository.updateUser(
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
    await _userRepository.updateUser(
      userId: loggedUserId,
      name: event.username,
    );
    emitCompleteStatus(emit, info: ProfileIdentitiesBlocInfo.dataSaved);
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
    await _userRepository.updateUser(
      userId: loggedUserId,
      surname: event.surname,
    );
    emitCompleteStatus(emit, info: ProfileIdentitiesBlocInfo.dataSaved);
  }

  Future<void> _updateEmail(
    ProfileIdentitiesEventUpdateEmail event,
    Emitter<ProfileIdentitiesState> emit,
  ) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
    try {
      await _authService.updateEmail(newEmail: event.newEmail);
      await _authService.sendEmailVerification();
      await _userRepository.updateUser(
        userId: loggedUserId,
        email: event.newEmail,
      );
      emitCompleteStatus(emit, info: ProfileIdentitiesBlocInfo.emailChanged);
    } on AuthException catch (authException) {
      if (authException.code == AuthExceptionCode.emailAlreadyInUse) {
        emitErrorStatus(emit, ProfileIdentitiesBlocError.emailAlreadyInUse);
      } else {
        emitUnknownErrorStatus(emit);
        rethrow;
      }
    } on NetworkException catch (networkException) {
      if (networkException.code == NetworkExceptionCode.requestFailed) {
        emitNoInternetConnectionStatus(emit);
      }
    } on UnknownException catch (unknownException) {
      emitUnknownErrorStatus(emit);
      throw unknownException.message;
    }
  }

  Future<void> _sendEmailVerification(
    ProfileIdentitiesEventSendEmailVerification event,
    Emitter<ProfileIdentitiesState> emit,
  ) async {
    emitLoadingStatus(emit);
    await _authService.sendEmailVerification();
    emitCompleteStatus(
      emit,
      info: ProfileIdentitiesBlocInfo.emailVerificationSent,
    );
  }

  Future<void> _updatePassword(
    ProfileIdentitiesEventUpdatePassword event,
    Emitter<ProfileIdentitiesState> emit,
  ) async {
    emitLoadingStatus(emit);
    try {
      await _authService.updatePassword(newPassword: event.newPassword);
      emitCompleteStatus(emit, info: ProfileIdentitiesBlocInfo.dataSaved);
    } on NetworkException catch (networkException) {
      if (networkException.code == NetworkExceptionCode.requestFailed) {
        emitNoInternetConnectionStatus(emit);
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
      emitCompleteStatus(emit, info: ProfileIdentitiesBlocInfo.accountDeleted);
    } on NetworkException catch (networkException) {
      if (networkException.code == NetworkExceptionCode.requestFailed) {
        emitNoInternetConnectionStatus(emit);
      }
    } on UnknownException catch (unknownException) {
      emitUnknownErrorStatus(emit);
      throw unknownException.message;
    }
  }

  Future<void> _reloadLoggedUser(
    ProfileIdentitiesEventReloadLoggedUser event,
    Emitter<ProfileIdentitiesState> emit,
  ) async {
    try {
      await _authService.reloadLoggedUser();
    } on NetworkException catch (networkException) {
      if (networkException.code == NetworkExceptionCode.requestFailed) {
        emitNoInternetConnectionStatus(emit);
      }
    }
  }

  Stream<User?> get _loggedUserData$ {
    return _authService.loggedUserId$.whereNotNull().switchMap(
          (String userId) => _userRepository.getUserById(userId: userId),
        );
  }

  Future<void> _deleteAllLoggedUserData(String loggedUserId) async {
    await _workoutRepository.deleteAllUserWorkouts(userId: loggedUserId);
    await _healthMeasurementRepository.deleteAllUserMeasurements(
      userId: loggedUserId,
    );
    await _bloodTestRepository.deleteAllUserTests(userId: loggedUserId);
    await _raceRepository.deleteAllUserRaces(userId: loggedUserId);
    await _userRepository.deleteUser(userId: loggedUserId);
    await _coachingRequestService.deleteCoachingRequestsByUserId(
      userId: loggedUserId,
    );
    await _personRepository.removeCoachIdInAllMatchingPersons(
      coachId: loggedUserId,
    );
  }
}

class ProfileIdentitiesBlocListenedParams extends Equatable {
  final String? loggedUserEmail;
  final bool? isEmailVerified;
  final User? loggedUserData;

  const ProfileIdentitiesBlocListenedParams({
    required this.loggedUserEmail,
    required this.isEmailVerified,
    required this.loggedUserData,
  });

  @override
  List<Object?> get props => [loggedUserEmail, isEmailVerified, loggedUserData];
}

enum ProfileIdentitiesBlocInfo {
  dataSaved,
  emailChanged,
  emailVerificationSent,
  accountDeleted,
}

enum ProfileIdentitiesBlocError { emailAlreadyInUse }
