import 'dart:async';
import 'dart:typed_data';

import 'package:rxdart/rxdart.dart';

import '../../../common/date_service.dart';
import '../../../dependency_injection.dart';
import '../../additional_model/cubit_state.dart';
import '../../additional_model/cubit_status.dart';
import '../../additional_model/cubit_with_status.dart';
import '../../entity/chat.dart';
import '../../entity/message.dart';
import '../../entity/person.dart';
import '../../repository/chat_repository.dart';
import '../../repository/message_repository.dart';
import '../../repository/person_repository.dart';
import '../../service/auth_service.dart';
import '../../service/connectivity_service.dart';

part 'chat_state.dart';

class ChatCubit extends CubitWithStatus<ChatState, dynamic, dynamic> {
  final String chatId;
  final AuthService _authService;
  final ChatRepository _chatRepository;
  final MessageRepository _messageRepository;
  final PersonRepository _personRepository;
  final DateService _dateService;
  final ConnectivityService _connectivityService;
  StreamSubscription<List<Message>>? _messagesListener;

  ChatCubit({
    required this.chatId,
    ChatState initialState = const ChatState(status: CubitStatusInitial()),
  })  : _authService = getIt<AuthService>(),
        _chatRepository = getIt<ChatRepository>(),
        _messageRepository = getIt<MessageRepository>(),
        _personRepository = getIt<PersonRepository>(),
        _dateService = getIt<DateService>(),
        _connectivityService = getIt<ConnectivityService>(),
        super(initialState);

  @override
  Future<void> close() {
    _messagesListener?.cancel();
    _messagesListener = null;
    return super.close();
  }

  Future<void> initialize() async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) return;
    final Chat chat =
        await _chatRepository.getChatById(chatId: chatId).whereNotNull().first;
    final Person recipient = await _personRepository
        .getPersonById(
          personId: chat.user1Id == loggedUserId ? chat.user2Id : chat.user1Id,
        )
        .whereNotNull()
        .first;
    _messagesListener ??=
        _messageRepository.getMessagesForChat(chatId: chatId).listen(
      (List<Message> messages) {
        final List<Message> sortedMessages = [...messages];
        sortedMessages.sort(
          (m1, m2) => m1.dateTime.isBefore(m2.dateTime) ? 1 : -1,
        );
        emit(state.copyWith(
          loggedUserId: loggedUserId,
          recipientFullName: '${recipient.name} ${recipient.surname}',
          messagesFromLatest: sortedMessages,
        ));
      },
    );
  }

  void messageChanged(String message) {
    emit(state.copyWith(messageToSend: message));
  }

  void addImagesToSend(List<Uint8List> newImagesToSend) {
    final List<Uint8List> updatedImagesToSend = [...state.imagesToSend];
    updatedImagesToSend.addAll(newImagesToSend);
    emit(state.copyWith(imagesToSend: updatedImagesToSend));
  }

  void deleteImageToSend(int imageIndex) {
    if (imageIndex < 0 || imageIndex >= state.imagesToSend.length) return;
    final List<Uint8List> updatedImagesToSend = [...state.imagesToSend];
    updatedImagesToSend.removeAt(imageIndex);
    emit(state.copyWith(imagesToSend: updatedImagesToSend));
  }

  Future<void> submitMessage() async {
    if (!state.canSubmitMessage) return;
    if (await _connectivityService.hasDeviceInternetConnection()) {
      final DateTime now = _dateService.getNow();
      emitLoadingStatus();
      await _messageRepository.addMessageToChat(
        chatId: chatId,
        senderId: state.loggedUserId!,
        dateTime: now,
        text: state.messageToSend,
        images: state.imagesToSend
            .asMap()
            .entries
            .map(
              (entry) => MessageImage(
                id: '',
                order: entry.key + 1,
                bytes: entry.value,
              ),
            )
            .toList(),
      );
      emit(state.copyWith(
        status: const CubitStatusComplete(),
        messageToSendAsNull: true,
        imagesToSend: [],
      ));
    } else {
      emitNoInternetConnectionStatus();
    }
  }

  Future<void> loadOlderMessages() async {
    final List<Message>? messages = state.messagesFromLatest;
    if (messages == null || messages.isEmpty) return;
    final String lastVisibleMessageId = messages.last.id;
    await _messageRepository.loadOlderMessagesForChat(
      chatId: chatId,
      lastVisibleMessageId: lastVisibleMessageId,
    );
  }
}
