import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../dependency_injection.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/bloc_with_status.dart';
import '../../additional_model/coaching_request.dart';
import '../../entity/user_basic_info.dart';
import '../../repository/user_basic_info_repository.dart';
import '../../repository/user_repository.dart';
import '../../service/auth_service.dart';
import '../../service/coaching_request_service.dart';

part 'coach_event.dart';
part 'coach_state.dart';

class CoachBloc
    extends BlocWithStatus<CoachEvent, CoachState, CoachBlocInfo, dynamic> {
  final AuthService _authService;
  final UserRepository _userRepository;
  final UserBasicInfoRepository _userBasicInfoRepository;
  final CoachingRequestService _coachingRequestService;

  CoachBloc({
    CoachState state = const CoachState(status: BlocStatusInitial()),
  })  : _authService = getIt<AuthService>(),
        _userRepository = getIt<UserRepository>(),
        _userBasicInfoRepository = getIt<UserBasicInfoRepository>(),
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
    final Stream<(UserBasicInfo?, List<CoachingRequestInfo>?)> stream$ =
        _authService.loggedUserId$.whereNotNull().switchMap(
              (String loggedUserId) => Rx.combineLatest2(
                _getCoach(loggedUserId),
                _getCoachingRequestsInfo(loggedUserId),
                (coachInfo, receivedRequests) => (coachInfo, receivedRequests),
              ),
            );
    await emit.forEach(
      stream$,
      onData: ((UserBasicInfo?, List<CoachingRequestInfo>?) data) => CoachState(
        status: const BlocStatusComplete(),
        coach: data.$1,
        receivedCoachingRequests: data.$1 != null ? null : data.$2,
      ),
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
        .senderInfo
        .id;
    await _userRepository.updateUser(userId: loggedUserId, coachId: senderId);
    await _coachingRequestService.updateCoachingRequestStatus(
      requestId: event.requestId,
      status: CoachingRequestStatus.accepted,
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

  Stream<UserBasicInfo?> _getCoach(String loggedUserId) => _userRepository
      .getUserById(userId: loggedUserId)
      .whereNotNull()
      .map((loggedUserData) => loggedUserData.coachId)
      .switchMap(
        (coachId) => coachId != null
            ? _userBasicInfoRepository.getUserBasicInfoByUserId(userId: coachId)
            : Stream.value(null),
      );

  Stream<List<CoachingRequestInfo>?> _getCoachingRequestsInfo(
    String loggedUserId,
  ) =>
      _coachingRequestService
          .getCoachingRequestsByReceiverId(receiverId: loggedUserId)
          .map(_linkCoachingRequestIdsWithSendersInfo)
          .switchMap(_switchToStreamWithCoachingRequestsInfo);

  List<Stream<(String, UserBasicInfo)>>? _linkCoachingRequestIdsWithSendersInfo(
    List<CoachingRequest>? coachingRequests,
  ) =>
      coachingRequests
          ?.map(
            (CoachingRequest request) => Rx.combineLatest2(
              Stream.value(request.id),
              _userBasicInfoRepository
                  .getUserBasicInfoByUserId(userId: request.senderId)
                  .whereNotNull(),
              (requestId, senderInfo) => (requestId, senderInfo),
            ),
          )
          .toList();

  Stream<List<CoachingRequestInfo>?> _switchToStreamWithCoachingRequestsInfo(
    List<Stream<(String, UserBasicInfo)>>? streams,
  ) =>
      streams == null
          ? Stream.value(null)
          : Rx.combineLatest(
              streams,
              (List<(String, UserBasicInfo)> values) => values
                  .map(
                    ((String, UserBasicInfo) data) => CoachingRequestInfo(
                      id: data.$1,
                      senderInfo: data.$2,
                    ),
                  )
                  .toList(),
            );
}

enum CoachBlocInfo { requestAccepted }
