import 'dart:async';

import 'package:firebase/firebase.dart';
import 'package:rxdart/rxdart.dart';

import '../../dependency_injection.dart';
import '../../domain/additional_model/state_repository.dart';
import '../../domain/entity/message.dart';
import '../../domain/repository/message_repository.dart';
import '../mapper/message_mapper.dart';

class MessageRepositoryImpl extends StateRepository<Message>
    implements MessageRepository {
  final FirebaseMessageService _dbMessageService;

  MessageRepositoryImpl({super.initialData})
      : _dbMessageService = getIt<FirebaseMessageService>();

  @override
  Stream<List<Message>> getMessagesForChat({required String chatId}) {
    final StreamController<bool> canEmit$ = StreamController()..add(false);
    _loadLatestMessagesForChatFromDb(chatId).then((_) => canEmit$.add(true));
    StreamSubscription<List<MessageDto>?>? newMessagesListener;
    return canEmit$.stream
        .switchMap(
          (bool canEmit) {
            return canEmit ? _getMessagesFromChat(chatId) : Stream.value(null);
          },
        )
        .whereNotNull()
        .doOnData(
          (_) {
            newMessagesListener ??= _dbMessageService
                .getAddedMessagesForChat(chatId: chatId)
                .whereNotNull()
                .listen(_manageNewMessages);
          },
        )
        .doOnCancel(
          () {
            newMessagesListener?.cancel();
            newMessagesListener = null;
          },
        );
  }

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
  Future<String?> addMessageToChat({
    required String chatId,
    required String senderId,
    required DateTime dateTime,
    String? text,
  }) async {
    final addedMessageDto = await _dbMessageService.addMessageToChat(
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

  Future<void> _manageNewMessages(List<MessageDto> messageDtos) async {
    if (messageDtos.isNotEmpty) {
      final List<Message> messages = await _mapMessagesFromDtos(messageDtos);
      addOrUpdateEntities(messages);
    }
  }

  Future<List<Message>> _mapMessagesFromDtos(List<MessageDto> dtos) async {
    final List<Message> messages = [];
    for (final messageDto in dtos) {
      messages.add(mapMessageFromDto(messageDto));
    }
    return messages;
  }
}
