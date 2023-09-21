import 'dart:async';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/date_service.dart';
import '../../../dependency_injection.dart';
import '../../additional_model/cubit_state.dart';
import '../../additional_model/cubit_status.dart';
import '../../additional_model/cubit_with_status.dart';
import '../../entity/chat.dart';
import '../../entity/message.dart';
import '../../entity/message_image.dart';
import '../../entity/person.dart';
import '../../extensions/message_images_extensions.dart';
import '../../repository/chat_repository.dart';
import '../../repository/message_image_repository.dart';
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
  final MessageImageRepository _messageImageRepository;
  final PersonRepository _personRepository;
  final DateService _dateService;
  final ConnectivityService _connectivityService;
  StreamSubscription<Chat?>? _chatListener;
  StreamSubscription<List<ChatMessage>>? _chatMessagesListener;

  ChatCubit({
    required this.chatId,
    ChatState initialState = const ChatState(status: CubitStatusInitial()),
  })  : _authService = getIt<AuthService>(),
        _chatRepository = getIt<ChatRepository>(),
        _messageRepository = getIt<MessageRepository>(),
        _messageImageRepository = getIt<MessageImageRepository>(),
        _personRepository = getIt<PersonRepository>(),
        _dateService = getIt<DateService>(),
        _connectivityService = getIt<ConnectivityService>(),
        super(initialState);

  @override
  Future<void> close() {
    _chatListener?.cancel();
    _chatMessagesListener?.cancel();
    return super.close();
  }

  void initializeChatListener() {
    _chatListener ??=
        _chatRepository.getChatById(chatId: chatId).whereNotNull().listen(
      (Chat chat) async {
        final String? loggedUserId = await _authService.loggedUserId$.first;
        final String recipientId =
            chat.user1Id == loggedUserId ? chat.user2Id : chat.user1Id;
        emit(state.copyWith(
          recipientFullName: await _loadRecipientFullName(recipientId),
          isRecipientTyping: recipientId == chat.user1Id
              ? chat.isUser1Typing
              : chat.isUser2Typing,
        ));
      },
    );
  }

  void initializeMessagesListener() {
    _chatMessagesListener ??= Rx.combineLatest2(
      _messageRepository.getMessagesForChat(chatId: chatId),
      _authService.loggedUserId$.whereNotNull(),
      (List<Message> messages, String loggedUserId) => (messages, loggedUserId),
    )
        .doOnData(
          ((List<Message>, String) data) {
            _markUnreadMessagesAsRead(messages: data.$1, loggedUserId: data.$2);
          },
        )
        .switchMap(
          ((List<Message>, String) data) => Rx.combineLatest(
            data.$1.map(
              (Message message) => _mapMessageToChatMessage(
                message: message,
                loggedUserId: data.$2,
              ),
            ),
            (List<ChatMessage> chatMessages) => chatMessages,
          ),
        )
        .listen(
          (List<ChatMessage> msgs) => emit(state.copyWith(
            messagesFromLatest: _sortChatMessagesDescendingBySendDateTime(msgs),
          )),
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
    if (!(await _connectivityService.hasDeviceInternetConnection())) {
      emitNoInternetConnectionStatus();
      return;
    }
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus();
      return;
    }
    final DateTime now = _dateService.getNow();
    emitLoadingStatus();
    final String? messageId = await _messageRepository.addMessage(
      status: MessageStatus.sent,
      chatId: chatId,
      senderId: loggedUserId,
      dateTime: now,
      text: state.messageToSend,
    );
    if (messageId != null && state.imagesToSend.isNotEmpty) {
      await _messageImageRepository.addImagesInOrderToMessage(
        messageId: messageId,
        bytesOfImages: state.imagesToSend,
      );
    }
    emit(state.copyWith(
      status: const CubitStatusLoading(),
      messageToSendAsNull: true,
      imagesToSend: [],
    ));
  }

  Future<void> loadOlderMessages() async {
    final List<ChatMessage>? messages = state.messagesFromLatest;
    if (messages == null || messages.isEmpty) return;
    final String lastVisibleMessageId = messages.last.id;
    await _messageRepository.loadOlderMessagesForChat(
      chatId: chatId,
      lastVisibleMessageId: lastVisibleMessageId,
    );
  }

  Future<String?> _loadRecipientFullName(String recipientId) async {
    final Person recipient = await _personRepository
        .getPersonById(personId: recipientId)
        .whereNotNull()
        .first;
    return '${recipient.name} ${recipient.surname}';
  }

  Future<void> _markUnreadMessagesAsRead({
    required List<Message> messages,
    required String loggedUserId,
  }) async {
    final List<String> idsOfUnreadMessagesSentByInterlocutor = messages
        .where(
          (Message message) =>
              message.status == MessageStatus.sent &&
              message.senderId != loggedUserId,
        )
        .map((Message message) => message.id)
        .toList();
    if (idsOfUnreadMessagesSentByInterlocutor.isNotEmpty) {
      await _messageRepository.markMessagesAsRead(
        messageIds: idsOfUnreadMessagesSentByInterlocutor,
      );
    }
  }

  Stream<ChatMessage> _mapMessageToChatMessage({
    required Message message,
    required String loggedUserId,
  }) =>
      _messageImageRepository.getImagesByMessageId(messageId: message.id).map(
            (List<MessageImage> messageImages) => ChatMessage(
              id: message.id,
              status: message.status,
              hasBeenSentByLoggedUser: message.senderId == loggedUserId,
              sendDateTime: message.dateTime,
              text: message.text,
              images: messageImages.sortByOrder(),
            ),
          );

  List<ChatMessage> _sortChatMessagesDescendingBySendDateTime(
    List<ChatMessage> chatMessages,
  ) {
    final List<ChatMessage> sortedChatMessages = [...chatMessages];
    sortedChatMessages.sort(
      (msg1, msg2) => msg1.sendDateTime.isBefore(msg2.sendDateTime) ? 1 : -1,
    );
    return sortedChatMessages;
  }
}
