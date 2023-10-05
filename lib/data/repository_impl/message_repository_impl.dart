import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:rxdart/rxdart.dart';

import '../../dependency_injection.dart';
import '../../domain/additional_model/state_repository.dart';
import '../../domain/entity/message.dart';
import '../../domain/repository/message_repository.dart';
import '../mapper/message_mapper.dart';
import '../mapper/message_status_mapper.dart';

class MessageRepositoryImpl extends StateRepository<Message>
    implements MessageRepository {
  final firebase.FirebaseMessageService _dbMessageService;
  final firebase.FirebaseChatService _dbChatService;

  MessageRepositoryImpl({super.initialData})
      : _dbMessageService = getIt<firebase.FirebaseMessageService>(),
        _dbChatService = getIt<firebase.FirebaseChatService>();

  @override
  Future<Message?> loadMessageById({required String messageId}) async {
    Message? foundMessage = await dataStream$
        .map((msgs) => msgs?.firstWhereOrNull((msg) => msg.id == messageId))
        .first;
    return foundMessage ?? await _loadMessageByIdFromDb(messageId);
  }

  @override
  Stream<List<Message>> getMessagesForChat({required String chatId}) {
    final StreamController<bool> canEmit$ = StreamController()..add(false);
    _loadLatestMessagesForChatFromDb(chatId).then((_) => canEmit$.add(true));
    StreamSubscription<List<firebase.MessageDto>?>? newMessagesListener;
    return canEmit$.stream
        .switchMap(
          (bool canEmit) =>
              canEmit ? _getMessagesFromChat(chatId) : Stream.value(null),
        )
        .whereNotNull()
        .doOnData(
          (_) => newMessagesListener ??= _dbMessageService
              .getAddedOrModifiedMessagesForChat(chatId: chatId)
              .whereNotNull()
              .listen(_manageAddedOrModifiedMessages),
        )
        .doOnCancel(() => newMessagesListener?.cancel());
  }

  @override
  Stream<bool> doesUserHaveUnreadMessagesInChat({
    required String chatId,
    required String userId,
  }) =>
      Rx.fromCallable(
        () async => await _dbChatService.getChatById(chatId: chatId).first,
      ).whereNotNull().switchMap(
        (firebase.ChatDto chatDto) {
          final String senderId =
              chatDto.user1Id == userId ? chatDto.user2Id : chatDto.user1Id;
          return dataStream$
              .map(
                (List<Message>? messages) => messages?.firstWhereOrNull(
                  (Message message) =>
                      message.chatId == chatId &&
                      message.senderId == senderId &&
                      message.status == MessageStatus.sent,
                ),
              )
              .switchMap(
                (Message? message) => message != null
                    ? Stream.value(true)
                    : _dbMessageService.areThereUnreadMessagesInChatSentByUser$(
                        chatId: chatId,
                        userId: senderId,
                      ),
              );
        },
      );

  @override
  Future<void> loadOlderMessagesForChat({
    required String chatId,
    required String lastVisibleMessageId,
  }) async {
    await _loadLatestMessagesForChatFromDb(
      chatId,
      lastVisibleMessageId: lastVisibleMessageId,
    );
  }

  @override
  Future<String?> addMessage({
    required MessageStatus status,
    required String chatId,
    required String senderId,
    required DateTime dateTime,
    String? text,
  }) async {
    final addedMessageDto = await _dbMessageService.addMessage(
      status: mapMessageStatusToDto(status),
      chatId: chatId,
      senderId: senderId,
      dateTime: dateTime,
      text: text,
    );
    if (addedMessageDto != null) {
      final Message addedMessage = mapMessageFromDto(addedMessageDto);
      addEntity(addedMessage);
      return addedMessageDto.id;
    }
    return null;
  }

  @override
  Future<void> markMessagesAsRead({required List<String> messageIds}) async {
    final List<Message> updatedMessages = [];
    for (final messageId in messageIds) {
      final updatedMessageDto = await _dbMessageService.updateMessageStatus(
        messageId: messageId,
        status: firebase.MessageStatus.read,
      );
      if (updatedMessageDto != null) {
        updatedMessages.add(mapMessageFromDto(updatedMessageDto));
      }
    }
    if (updatedMessages.isNotEmpty) addOrUpdateEntities(updatedMessages);
  }

  @override
  Future<void> deleteMessagesForChat({required String chatId}) async {
    //TODO
    throw UnimplementedError();
  }

  Future<Message?> _loadMessageByIdFromDb(String messageId) async {
    final firebase.MessageDto? messageDto =
        await _dbMessageService.loadMessageById(messageId: messageId);
    if (messageDto == null) return null;
    final Message message = mapMessageFromDto(messageDto);
    addEntity(message);
    return message;
  }

  Future<void> _loadLatestMessagesForChatFromDb(
    String chatId, {
    String? lastVisibleMessageId,
  }) async {
    final messageDtos = await _dbMessageService.loadMessagesForChat(
      chatId: chatId,
      lastVisibleMessageId: lastVisibleMessageId,
    );
    final List<Message> messages = await _mapMessagesFromDtos(messageDtos);
    addOrUpdateEntities(messages);
  }

  Stream<List<Message>?> _getMessagesFromChat(String chatId) => dataStream$.map(
        (msgs) => msgs?.where((message) => message.chatId == chatId).toList(),
      );

  Future<void> _manageAddedOrModifiedMessages(
    List<firebase.MessageDto> messageDtos,
  ) async {
    if (messageDtos.isNotEmpty) {
      final List<Message> messages = await _mapMessagesFromDtos(messageDtos);
      addOrUpdateEntities(messages);
    }
  }

  Future<List<Message>> _mapMessagesFromDtos(
    List<firebase.MessageDto> dtos,
  ) async {
    final List<Message> messages = [];
    for (final messageDto in dtos) {
      messages.add(mapMessageFromDto(messageDto));
    }
    return messages;
  }
}
