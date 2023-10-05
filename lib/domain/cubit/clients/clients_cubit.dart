import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../../dependency_injection.dart';
import '../../additional_model/coaching_request.dart';
import '../../additional_model/coaching_request_with_person.dart';
import '../../additional_model/cubit_state.dart';
import '../../additional_model/cubit_status.dart';
import '../../additional_model/cubit_with_status.dart';
import '../../entity/person.dart';
import '../../repository/person_repository.dart';
import '../../service/auth_service.dart';
import '../../service/coaching_request_service.dart';
import '../../service/connectivity_service.dart';
import '../../use_case/delete_chat_use_case.dart';
import '../../use_case/get_received_coaching_requests_with_sender_info_use_case.dart';
import '../../use_case/get_sent_coaching_requests_with_receiver_info_use_case.dart';
import '../../use_case/load_chat_id_use_case.dart';

part 'clients_state.dart';

class ClientsCubit
    extends CubitWithStatus<ClientsState, ClientsCubitInfo, ClientsCubitError> {
  final ConnectivityService _connectivityService;
  final AuthService _authService;
  final CoachingRequestService _coachingRequestService;
  final PersonRepository _personRepository;
  final GetSentCoachingRequestsWithReceiverInfoUseCase
      _getSentCoachingRequestsWithReceiverInfoUseCase;
  final GetReceivedCoachingRequestsWithSenderInfoUseCase
      _getReceivedCoachingRequestsWithSenderInfoUseCase;
  final LoadChatIdUseCase _loadChatIdUseCase;
  final DeleteChatUseCase _deleteChatUseCase;
  StreamSubscription<ClientsState>? _listener;

  ClientsCubit({
    ClientsState initialState =
        const ClientsState(status: CubitStatusInitial()),
  })  : _connectivityService = getIt<ConnectivityService>(),
        _authService = getIt<AuthService>(),
        _coachingRequestService = getIt<CoachingRequestService>(),
        _personRepository = getIt<PersonRepository>(),
        _getSentCoachingRequestsWithReceiverInfoUseCase =
            getIt<GetSentCoachingRequestsWithReceiverInfoUseCase>(),
        _getReceivedCoachingRequestsWithSenderInfoUseCase =
            getIt<GetReceivedCoachingRequestsWithSenderInfoUseCase>(),
        _loadChatIdUseCase = getIt<LoadChatIdUseCase>(),
        _deleteChatUseCase = getIt<DeleteChatUseCase>(),
        super(initialState);

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }

  void initialize() {
    _listener ??= _connectivityService.connectivityStatus$
        .switchMap(
          (bool hasDeviceInternetConnection) => hasDeviceInternetConnection
              ? _authService.loggedUserId$.switchMap(
                  (String? loggedUserId) => loggedUserId == null
                      ? Stream.value(state.copyWith())
                      : Rx.combineLatest3(
                          _getSentRequests(loggedUserId),
                          _getReceivedRequests(loggedUserId),
                          _getClients(loggedUserId),
                          (
                            List<CoachingRequestWithPerson> sentRequests,
                            List<CoachingRequestWithPerson> receivedRequests,
                            List<Person> clients,
                          ) =>
                              state.copyWith(
                            sentRequests: sentRequests,
                            receivedRequests: receivedRequests,
                            clients: clients,
                          ),
                        ),
                )
              : Stream.value(state.copyWith(
                  status: const CubitStatusNoInternetConnection(),
                )),
        )
        .listen(emit);
  }

  Future<void> acceptRequest(String requestId) async {
    final String? loggedUserId = await _loadLoggedUserId();
    if (loggedUserId == null) {
      emitNoLoggedUserStatus();
      return;
    }
    emitLoadingStatus();
    final String senderId = state.receivedRequests!
        .firstWhere((req) => req.id == requestId)
        .person
        .id;
    await _personRepository.refreshPersonById(personId: senderId);
    final Person? client =
        await _personRepository.getPersonById(personId: senderId).first;
    if (client == null) return;
    if (client.coachId != null) {
      emitErrorStatus(ClientsCubitError.personAlreadyHasCoach);
      return;
    }
    await _personRepository.updateCoachIdOfPerson(
      personId: senderId,
      coachId: loggedUserId,
    );
    await _coachingRequestService.updateCoachingRequest(
      requestId: requestId,
      isAccepted: true,
    );
    emitCompleteStatus(info: ClientsCubitInfo.requestAccepted);
  }

  Future<void> deleteRequest(String requestId) async {
    emitLoadingStatus();
    await _coachingRequestService.deleteCoachingRequest(requestId: requestId);
    emitCompleteStatus(info: ClientsCubitInfo.requestDeleted);
  }

  Future<void> openChatWithClient(String clientId) async {
    final String? loggedUserId = await _loadLoggedUserId();
    if (loggedUserId == null) return;
    emitLoadingStatus();
    final String? chatId = await _loadChatIdUseCase.execute(
      user1Id: loggedUserId,
      user2Id: clientId,
    );
    emit(state.copyWith(selectedChatId: chatId));
  }

  Future<void> deleteClient(String clientId) async {
    final String? loggedUserId = await _loadLoggedUserId();
    if (loggedUserId == null) return;
    emitLoadingStatus();
    await _personRepository.updateCoachIdOfPerson(
      personId: clientId,
      coachId: null,
    );
    await _coachingRequestService.deleteCoachingRequestBetweenUsers(
      user1Id: loggedUserId,
      user2Id: clientId,
    );
    final String? chatId = await _loadChatIdUseCase.execute(
      user1Id: loggedUserId,
      user2Id: clientId,
    );
    if (chatId != null) await _deleteChatUseCase.execute(chatId: chatId);
    emitCompleteStatus(info: ClientsCubitInfo.clientDeleted);
  }

  Future<void> refreshClients() async {
    if (state.clients?.isNotEmpty == true) {
      for (final Person client in state.clients!) {
        await _personRepository.refreshPersonById(personId: client.id);
      }
    }
  }

  Future<bool> checkIfClientIsStillClient(String clientId) async {
    final String? loggedUserId = await _loadLoggedUserId();
    if (loggedUserId == null) {
      emitNoLoggedUserStatus();
      return false;
    }
    await _personRepository.refreshPersonById(personId: clientId);
    final Person? client =
        await _personRepository.getPersonById(personId: clientId).first;
    if (client?.coachId != loggedUserId) {
      emitErrorStatus(ClientsCubitError.clientIsNoLongerClient);
      return false;
    }
    return true;
  }

  Stream<List<Person>> _getClients(String loggedUserId) => _personRepository
      .getPersonsByCoachId(coachId: loggedUserId)
      .map((List<Person>? clients) => [...?clients]);

  Stream<List<CoachingRequestWithPerson>> _getSentRequests(
    String loggedUserId,
  ) =>
      _getSentCoachingRequestsWithReceiverInfoUseCase.execute(
        senderId: loggedUserId,
        requestDirection: CoachingRequestDirection.coachToClient,
        requestStatuses: SentCoachingRequestStatuses.onlyUnaccepted,
      );

  Stream<List<CoachingRequestWithPerson>> _getReceivedRequests(
    String loggedUserId,
  ) =>
      _getReceivedCoachingRequestsWithSenderInfoUseCase.execute(
        receiverId: loggedUserId,
        requestDirection: CoachingRequestDirection.clientToCoach,
        requestStatuses: ReceivedCoachingRequestStatuses.onlyUnaccepted,
      );

  Future<String?> _loadLoggedUserId() async =>
      await _authService.loggedUserId$.first;
}

enum ClientsCubitInfo { requestAccepted, requestDeleted, clientDeleted }

enum ClientsCubitError { personAlreadyHasCoach, clientIsNoLongerClient }
