import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../dependency_injection.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/bloc_with_status.dart';
import '../../additional_model/coaching_request.dart';
import '../../entity/person.dart';
import '../../repository/person_repository.dart';
import '../../repository/user_repository.dart';
import '../../service/auth_service.dart';
import '../../service/coaching_request_service.dart';

part 'coach_event.dart';
part 'coach_state.dart';

class CoachBloc
    extends BlocWithStatus<CoachEvent, CoachState, CoachBlocInfo, dynamic> {
  final AuthService _authService;
  final UserRepository _userRepository;
  final PersonRepository _personRepository;
  final CoachingRequestService _coachingRequestService;

  CoachBloc({
    CoachState state = const CoachState(status: BlocStatusInitial()),
  })  : _authService = getIt<AuthService>(),
        _userRepository = getIt<UserRepository>(),
        _personRepository = getIt<PersonRepository>(),
        _coachingRequestService = getIt<CoachingRequestService>(),
        super(state) {
    on<CoachEventInitialize>(_initialize);
    on<CoachEventAcceptRequest>(_acceptRequest);
    on<CoachEventDeleteRequest>(_deleteRequest);
  }

  Future<void> _initialize(
    CoachEventInitialize event,
    Emitter<CoachState> emit,
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
          return CoachState(status: const BlocStatusComplete(), coach: data);
        } else if (data is List<CoachingRequestInfo>) {
          return CoachState(
            status: const BlocStatusComplete(),
            receivedCoachingRequests: data,
          );
        }
        return const CoachState(status: BlocStatusComplete());
      },
    );
  }

  Future<void> _acceptRequest(
    CoachEventAcceptRequest event,
    Emitter<CoachState> emit,
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
        .sender
        .id;
    await _userRepository.updateUser(userId: loggedUserId, coachId: senderId);
    await _coachingRequestService.updateCoachingRequest(
      requestId: event.requestId,
      isAccepted: true,
    );
    emitCompleteStatus(emit, info: CoachBlocInfo.requestAccepted);
  }

  Future<void> _deleteRequest(
    CoachEventDeleteRequest event,
    Emitter<CoachState> emit,
  ) async {
    emitLoadingStatus(emit);
    await _coachingRequestService.deleteCoachingRequest(
      requestId: event.requestId,
    );
    emitCompleteStatus(emit);
  }

  Stream<(String, String?)> _combineWithCoachId(String loggedUserId) =>
      _userRepository
          .getUserById(userId: loggedUserId)
          .whereNotNull()
          .map((loggedUserData) => (loggedUserData.id, loggedUserData.coachId));

  Stream<List<CoachingRequestInfo>?> _getCoachingRequestsInfo(
    String loggedUserId,
  ) =>
      _coachingRequestService
          .getCoachingRequestsByReceiverId(receiverId: loggedUserId)
          .map((requests) => requests.where((request) => !request.isAccepted))
          .map(_combineCoachingRequestIdsWithSendersInfo)
          .switchMap(_switchToStreamWithCoachingRequestsInfo);

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

  Stream<List<CoachingRequestInfo>?> _switchToStreamWithCoachingRequestsInfo(
    List<Stream<(String, Person)>>? streams,
  ) =>
      streams == null || streams.isEmpty == true
          ? Stream.value([])
          : Rx.combineLatest(
              streams,
              (List<(String, Person)> values) => values
                  .map(
                    ((String, Person) data) => CoachingRequestInfo(
                      id: data.$1,
                      sender: data.$2,
                    ),
                  )
                  .toList(),
            );
}

enum CoachBlocInfo { requestAccepted }
