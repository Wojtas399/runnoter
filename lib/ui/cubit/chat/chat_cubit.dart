import 'dart:async';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../common/date_service.dart';
import '../../../../../data/entity/message_image.dart';
import '../../../../../data/entity/person.dart';
import '../../../../../data/interface/repository/chat_repository.dart';
import '../../../../../data/interface/repository/message_image_repository.dart';
import '../../../../../data/interface/repository/message_repository.dart';
import '../../../../../data/interface/repository/person_repository.dart';
import '../../../../../data/interface/service/auth_service.dart';
import '../../../../../dependency_injection.dart';
import '../../../data/model/chat.dart';
import '../../../data/model/message.dart';
import '../../extensions/message_images_extensions.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final String chatId;
  final AuthService _authService;
  final ChatRepository _chatRepository;
  final MessageRepository _messageRepository;
  final MessageImageRepository _messageImageRepository;
  final PersonRepository _personRepository;
  final DateService _dateService;
  StreamSubscription<Chat?>? _chatListener;
  StreamSubscription<List<ChatMessage>>? _chatMessagesListener;
  Timer? _recipientTypingTimer;
  Timer? _typingInterval;
  Timer? _typingInactivityTimer;

  ChatCubit({
    required this.chatId,
    ChatState initialState = const ChatState(),
  })  : _authService = getIt<AuthService>(),
        _chatRepository = getIt<ChatRepository>(),
        _messageRepository = getIt<MessageRepository>(),
        _messageImageRepository = getIt<MessageImageRepository>(),
        _personRepository = getIt<PersonRepository>(),
        _dateService = getIt<DateService>(),
        super(initialState);

  @override
  Future<void> close() {
    _chatListener?.cancel();
    _chatMessagesListener?.cancel();
    _recipientTypingTimer?.cancel();
    _typingInterval?.cancel();
    _typingInactivityTimer?.cancel();
    return super.close();
  }

  Future<void> initializeChatListener() async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    _chatListener ??=
        _chatRepository.getChatById(chatId: chatId).whereNotNull().listen(
      (Chat chat) async {
        _resetRecipientTypingTimer();
        final (String?, int?) recipientData =
            await _getRecipientData(chat, loggedUserId);
        final int? secondsToLastRecipientTypingDateTime = recipientData.$2;
        emit(state.copyWith(
          recipientFullName: recipientData.$1,
          isRecipientTyping: secondsToLastRecipientTypingDateTime != null
              ? secondsToLastRecipientTypingDateTime <= 5
              : null,
        ));
      },
    );
  }

  Future<void> initializeMessagesListener() async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) return;
    _chatMessagesListener ??= _messageRepository
        .getMessagesForChat(chatId: chatId)
        .doOnData(
          (messages) => _markUnreadMessagesAsRead(messages, loggedUserId),
        )
        .switchMap(
          (List<Message> messages) => messages.isEmpty
              ? Stream.value(<ChatMessage>[])
              : Rx.combineLatest(
                  messages.map(
                    (message) =>
                        _mapMessageToChatMessage(message, loggedUserId),
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
    if (_typingInterval == null) {
      _updateLoggedUserTypingDateTime(_dateService.getNow());
      _typingInterval = Timer.periodic(
        const Duration(seconds: 2),
        (_) => _updateLoggedUserTypingDateTime(_dateService.getNow()),
      );
    }
    _typingInactivityTimer?.cancel();
    _typingInactivityTimer =
        Timer(const Duration(seconds: 4), _cleanTypingTimers);
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
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) return;
    final DateTime now = _dateService.getNow();
    final DateTime dateTime5minAgo =
        _dateService.getNow().subtract(const Duration(minutes: 5));
    await _updateLoggedUserTypingDateTime(dateTime5minAgo);
    _cleanTypingTimers();
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

  void _resetRecipientTypingTimer() {
    _recipientTypingTimer?.cancel();
    _recipientTypingTimer = Timer(
      const Duration(seconds: 5),
      () => emit(state.copyWith(isRecipientTyping: false)),
    );
  }

  Future<(String?, int?)> _getRecipientData(
    Chat chat,
    String? loggedUserId,
  ) async {
    final (String, DateTime?) recipientData = chat.user1Id == loggedUserId
        ? (chat.user2Id, chat.user2LastTypingDateTime)
        : (chat.user1Id, chat.user1LastTypingDateTime);
    final String recipientId = recipientData.$1;
    final DateTime? recipientLastTypingDateTime = recipientData.$2;
    final Person recipient = await _personRepository
        .getPersonById(personId: recipientId)
        .whereNotNull()
        .first;
    final String recipientFullName = '${recipient.name} ${recipient.surname}';
    final int? secondsToLastRecipientTypingDateTime =
        recipientLastTypingDateTime != null
            ? _dateService
                .getNow()
                .difference(recipientLastTypingDateTime)
                .inSeconds
            : null;
    return (recipientFullName, secondsToLastRecipientTypingDateTime);
  }

  Future<void> _markUnreadMessagesAsRead(
    List<Message> messages,
    String loggedUserId,
  ) async {
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

  Stream<ChatMessage> _mapMessageToChatMessage(
    Message message,
    String loggedUserId,
  ) =>
      _messageImageRepository.getImagesByMessageId(messageId: message.id).map(
            (List<MessageImage> messageImages) => ChatMessage(
              id: message.id,
              status: message.status,
              hasBeenSentByLoggedUser: message.senderId == loggedUserId,
              dateTime: message.dateTime,
              text: message.text,
              images: messageImages.sortByOrder(),
            ),
          );

  List<ChatMessage> _sortChatMessagesDescendingBySendDateTime(
    List<ChatMessage> chatMessages,
  ) {
    final List<ChatMessage> sortedChatMessages = [...chatMessages];
    sortedChatMessages.sort(
      (msg1, msg2) => msg1.dateTime.isBefore(msg2.dateTime) ? 1 : -1,
    );
    return sortedChatMessages;
  }

  Future<void> _updateLoggedUserTypingDateTime(DateTime dateTime) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) return;
    final Chat? chat = await _chatRepository.getChatById(chatId: chatId).first;
    if (chat == null) return;
    await _chatRepository.updateChat(
      chatId: chatId,
      user1LastTypingDateTime: chat.user1Id == loggedUserId ? dateTime : null,
      user2LastTypingDateTime: chat.user2Id == loggedUserId ? dateTime : null,
    );
  }

  void _cleanTypingTimers() {
    _typingInterval?.cancel();
    _typingInactivityTimer?.cancel();
    _typingInterval = null;
    _typingInactivityTimer = null;
  }
}
