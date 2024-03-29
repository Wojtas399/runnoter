import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../data/model/custom_exception.dart';
import '../../../../../../dependency_injection.dart';
import '../../../../data/model/user.dart';
import '../../../../data/repository/blood_test/blood_test_repository.dart';
import '../../../../data/repository/health_measurement/health_measurement_repository.dart';
import '../../../../data/repository/person/person_repository.dart';
import '../../../../data/repository/race/race_repository.dart';
import '../../../../data/repository/user/user_repository.dart';
import '../../../../data/repository/workout/workout_repository.dart';
import '../../../../data/service/auth/auth_service.dart';
import '../../../../data/service/coaching_request/coaching_request_service.dart';
import '../../../model/cubit_state.dart';
import '../../../model/cubit_status.dart';
import '../../../model/cubit_with_status.dart';

part 'profile_identities_state.dart';

class ProfileIdentitiesCubit extends CubitWithStatus<ProfileIdentitiesState,
    ProfileIdentitiesCubitInfo, ProfileIdentitiesCubitError> {
  final AuthService _authService;
  final UserRepository _userRepository;
  final WorkoutRepository _workoutRepository;
  final HealthMeasurementRepository _healthMeasurementRepository;
  final BloodTestRepository _bloodTestRepository;
  final RaceRepository _raceRepository;
  final CoachingRequestService _coachingRequestService;
  final PersonRepository _personRepository;
  StreamSubscription<ProfileIdentitiesCubitListenedParams>? _listener;

  ProfileIdentitiesCubit({
    ProfileIdentitiesState state = const ProfileIdentitiesState(
      status: CubitStatusInitial(),
    ),
  })  : _authService = getIt<AuthService>(),
        _userRepository = getIt<UserRepository>(),
        _workoutRepository = getIt<WorkoutRepository>(),
        _healthMeasurementRepository = getIt<HealthMeasurementRepository>(),
        _bloodTestRepository = getIt<BloodTestRepository>(),
        _raceRepository = getIt<RaceRepository>(),
        _coachingRequestService = getIt<CoachingRequestService>(),
        _personRepository = getIt<PersonRepository>(),
        super(state);

  @override
  Future<void> close() {
    _listener?.cancel();
    _listener = null;
    return super.close();
  }

  Future<void> initialize() async {
    _listener ??= Rx.combineLatest3(
      _authService.loggedUserEmail$,
      _authService.hasLoggedUserVerifiedEmail$,
      _loggedUserData$,
      (
        String? loggedUserEmail,
        bool? hasLoggedUserVerifiedEmail,
        User? loggedUserData,
      ) =>
          ProfileIdentitiesCubitListenedParams(
        loggedUserEmail: loggedUserEmail,
        isEmailVerified: hasLoggedUserVerifiedEmail,
        loggedUserData: loggedUserData,
      ),
    ).listen(
      (ProfileIdentitiesCubitListenedParams params) => emit(state.copyWith(
        accountType: params.loggedUserData?.accountType,
        gender: params.loggedUserData?.gender,
        name: params.loggedUserData?.name,
        surname: params.loggedUserData?.surname,
        email: params.loggedUserEmail,
        dateOfBirth: params.loggedUserData?.dateOfBirth,
        isEmailVerified: params.isEmailVerified,
      )),
    );
  }

  Future<void> updateGender(Gender gender) async {
    final Gender? previousGender = state.gender;
    if (gender == previousGender) return;
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus();
      return;
    }
    emit(state.copyWith(gender: gender));
    try {
      await _userRepository.updateUser(userId: loggedUserId, gender: gender);
    } catch (_) {
      emit(state.copyWith(gender: previousGender));
    }
  }

  Future<void> updateName(String username) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus();
      return;
    }
    emitLoadingStatus();
    await _userRepository.updateUser(userId: loggedUserId, name: username);
    emitCompleteStatus(info: ProfileIdentitiesCubitInfo.dataSaved);
  }

  Future<void> updateSurname(String surname) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus();
      return;
    }
    emitLoadingStatus();
    await _userRepository.updateUser(userId: loggedUserId, surname: surname);
    emitCompleteStatus(info: ProfileIdentitiesCubitInfo.dataSaved);
  }

  Future<void> updateDateOfBirth(DateTime dateOfBirth) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus();
      return;
    }
    emitLoadingStatus();
    await _userRepository.updateUser(
      userId: loggedUserId,
      dateOfBirth: dateOfBirth,
    );
    emitCompleteStatus(info: ProfileIdentitiesCubitInfo.dataSaved);
  }

  Future<void> updateEmail(String email) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus();
      return;
    }
    emitLoadingStatus();
    try {
      await _authService.updateEmail(newEmail: email);
      await _authService.sendEmailVerification();
      await _userRepository.updateUser(userId: loggedUserId, email: email);
      emitCompleteStatus(info: ProfileIdentitiesCubitInfo.emailChanged);
    } on AuthException catch (authException) {
      if (authException.code == AuthExceptionCode.emailAlreadyInUse) {
        emitErrorStatus(ProfileIdentitiesCubitError.emailAlreadyInUse);
      } else {
        emitUnknownErrorStatus();
        rethrow;
      }
    } on NetworkException catch (networkException) {
      if (networkException.code == NetworkExceptionCode.requestFailed) {
        emitNoInternetConnectionStatus();
      }
    } on UnknownException catch (_) {
      emitUnknownErrorStatus();
      rethrow;
    }
  }

  Future<void> sendEmailVerification() async {
    emitLoadingStatus();
    await _authService.sendEmailVerification();
    emitCompleteStatus(info: ProfileIdentitiesCubitInfo.emailVerificationSent);
  }

  Future<void> updatePassword(String newPassword) async {
    emitLoadingStatus();
    try {
      await _authService.updatePassword(newPassword: newPassword);
      emitCompleteStatus(info: ProfileIdentitiesCubitInfo.dataSaved);
    } on NetworkException catch (networkException) {
      if (networkException.code == NetworkExceptionCode.requestFailed) {
        emitNoInternetConnectionStatus();
      }
    } on UnknownException catch (_) {
      emitUnknownErrorStatus();
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus();
      return;
    }
    emitLoadingStatus();
    try {
      await _deleteAllLoggedUserData(loggedUserId);
      await _authService.deleteAccount();
      emitCompleteStatus(info: ProfileIdentitiesCubitInfo.accountDeleted);
    } on NetworkException catch (networkException) {
      if (networkException.code == NetworkExceptionCode.requestFailed) {
        emitNoInternetConnectionStatus();
      }
    } on UnknownException catch (_) {
      emitUnknownErrorStatus();
      rethrow;
    }
  }

  Future<void> reloadLoggedUser() async {
    try {
      await _authService.reloadLoggedUser();
    } on NetworkException catch (networkException) {
      if (networkException.code == NetworkExceptionCode.requestFailed) {
        emitNoInternetConnectionStatus();
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

class ProfileIdentitiesCubitListenedParams extends Equatable {
  final String? loggedUserEmail;
  final bool? isEmailVerified;
  final User? loggedUserData;

  const ProfileIdentitiesCubitListenedParams({
    required this.loggedUserEmail,
    required this.isEmailVerified,
    required this.loggedUserData,
  });

  @override
  List<Object?> get props => [loggedUserEmail, isEmailVerified, loggedUserData];
}

enum ProfileIdentitiesCubitInfo {
  dataSaved,
  emailChanged,
  emailVerificationSent,
  accountDeleted,
}

enum ProfileIdentitiesCubitError { emailAlreadyInUse }
