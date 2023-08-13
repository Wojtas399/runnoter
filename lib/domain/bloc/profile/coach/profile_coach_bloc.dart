import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../dependency_injection.dart';
import '../../../additional_model/bloc_state.dart';
import '../../../additional_model/bloc_status.dart';
import '../../../additional_model/bloc_with_status.dart';
import '../../../additional_model/coaching_request.dart';
import '../../../entity/person.dart';
import '../../../repository/person_repository.dart';
import '../../../repository/user_repository.dart';
import '../../../service/auth_service.dart';
import '../../../service/coaching_request_service.dart';

part 'profile_coach_event.dart';
part 'profile_coach_state.dart';

class ProfileCoachBloc extends BlocWithStatus<ProfileCoachEvent,
    ProfileCoachState, ProfileCoachBlocInfo, dynamic> {
  final AuthService _authService;
  final UserRepository _userRepository;
  final PersonRepository _personRepository;
  final CoachingRequestService _coachingRequestService;

  ProfileCoachBloc({
    ProfileCoachState state = const ProfileCoachState(
      status: BlocStatusInitial(),
    ),
  })  : _authService = getIt<AuthService>(),
        _userRepository = getIt<UserRepository>(),
        _personRepository = getIt<PersonRepository>(),
        _coachingRequestService = getIt<CoachingRequestService>(),
        super(state) {
    on<ProfileCoachEventInitialize>(_initialize);
    on<ProfileCoachEventAcceptRequest>(_acceptRequest);
    on<ProfileCoachEventDeleteRequest>(_deleteRequest);
    on<ProfileCoachEventDeleteCoach>(_deleteCoach);
  }

  Future<void> _initialize(
    ProfileCoachEventInitialize event,
    Emitter<ProfileCoachState> emit,
  ) async {
    final Stream stream$ = _authService.loggedUserId$
        .whereNotNull()
        .switchMap(_combineWithCoachId)
        .switchMap(
          ((String, String?) data) => data.$2 != null
              ? _personRepository.getPersonById(personId: data.$2!)
              : _getCoachingRequestsInfo(data.$1),
        );
    await emit.forEach(
      stream$,
      onData: (data) {
        if (data is Person) {
          return ProfileCoachState(
              status: const BlocStatusComplete(), coach: data);
        } else if (data is List<CoachingRequestDetails>) {
          return ProfileCoachState(
            status: const BlocStatusComplete(),
            receivedCoachingRequests: data,
          );
        }
        return const ProfileCoachState(status: BlocStatusComplete());
      },
    );
  }

  Future<void> _acceptRequest(
    ProfileCoachEventAcceptRequest event,
    Emitter<ProfileCoachState> emit,
  ) async {
    if (state.receivedCoachingRequests == null) return;
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
    final String senderId = state.receivedCoachingRequests!
        .firstWhere((request) => request.id == event.requestId)
        .personToDisplay
        .id;
    await _coachingRequestService.updateCoachingRequest(
      requestId: event.requestId,
      isAccepted: true,
    );
    await _coachingRequestService.deleteUnacceptedCoachingRequestsByReceiverId(
      receiverId: loggedUserId,
    );
    await _userRepository.updateUser(userId: loggedUserId, coachId: senderId);
    emitCompleteStatus(emit, info: ProfileCoachBlocInfo.requestAccepted);
  }

  Future<void> _deleteRequest(
    ProfileCoachEventDeleteRequest event,
    Emitter<ProfileCoachState> emit,
  ) async {
    emitLoadingStatus(emit);
    await _coachingRequestService.deleteCoachingRequest(
      requestId: event.requestId,
    );
    emitCompleteStatus(emit, info: ProfileCoachBlocInfo.requestDeleted);
  }

  Future<void> _deleteCoach(
    ProfileCoachEventDeleteCoach event,
    Emitter<ProfileCoachState> emit,
  ) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
    await _userRepository.updateUser(userId: loggedUserId, coachIdAsNull: true);
    emitCompleteStatus(emit, info: ProfileCoachBlocInfo.coachDeleted);
  }

  Stream<(String, String?)> _combineWithCoachId(String loggedUserId) =>
      _userRepository
          .getUserById(userId: loggedUserId)
          .whereNotNull()
          .map((loggedUserData) => (loggedUserData.id, loggedUserData.coachId));

  Stream<List<CoachingRequestDetails>?> _getCoachingRequestsInfo(
    String loggedUserId,
  ) =>
      _coachingRequestService
          .getCoachingRequestsByReceiverId(
            receiverId: loggedUserId,
            direction: CoachingRequestDirection.coachToClient,
          )
          .map((requests) => requests.where((request) => !request.isAccepted))
          .map(_combineCoachingRequestIdsWithSendersInfo)
          .switchMap(_switchToStreamWithCoachingRequestsDetails);

  List<Stream<(String, Person)>>? _combineCoachingRequestIdsWithSendersInfo(
    Iterable<CoachingRequest> coachingRequests,
  ) =>
      coachingRequests.isEmpty
          ? []
          : coachingRequests
              .map(
                (CoachingRequest request) => Rx.combineLatest2(
                  Stream.value(request.id),
                  _personRepository
                      .getPersonById(personId: request.senderId)
                      .whereNotNull(),
                  (requestId, senderInfo) => (requestId, senderInfo),
                ),
              )
              .toList();

  Stream<List<CoachingRequestDetails>?>
      _switchToStreamWithCoachingRequestsDetails(
    List<Stream<(String, Person)>>? streams,
  ) =>
          streams == null || streams.isEmpty == true
              ? Stream.value([])
              : Rx.combineLatest(
                  streams,
                  (List<(String, Person)> values) => values
                      .map(
                        ((String, Person) data) => CoachingRequestDetails(
                          id: data.$1,
                          personToDisplay: data.$2,
                        ),
                      )
                      .toList(),
                );
}

enum ProfileCoachBlocInfo { requestAccepted, requestDeleted, coachDeleted }
