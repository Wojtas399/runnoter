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
  final FirebaseMessageService _firebaseMessageService;

  MessageRepositoryImpl({super.initialData})
      : _firebaseMessageService = getIt<FirebaseMessageService>();

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
        .doOnListen(
          () {
            newMessagesListener ??= _firebaseMessageService
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
  Future<void> addMessageToChat({
    required String chatId,
    required String senderId,
    required DateTime dateTime,
    String? text,
    List<MessageImage> images = const [],
  }) async {
    final addedMessageDto = await _firebaseMessageService.addMessageToChat(
      chatId: chatId,
      senderId: senderId,
      text: text,
      dateTime: dateTime,
    );
    if (addedMessageDto != null) {
      final Message addedMessage = mapMessageFromDto(addedMessageDto);
      addEntity(addedMessage);
    }
  }

  Future<void> _loadLatestMessagesForChatFromDb(
    String chatId, {
    String? lastVisibleMessageId,
  }) async {
    final messageDtos = await _firebaseMessageService.loadMessagesForChat(
      chatId: chatId,
      lastVisibleMessageId: lastVisibleMessageId,
    );
    final List<Message> messages = messageDtos.map(mapMessageFromDto).toList();
    addOrUpdateEntities(messages);
  }

  Stream<List<Message>?> _getMessagesFromChat(String chatId) => dataStream$.map(
        (List<Message>? messages) => messages
            ?.where((Message message) => message.chatId == chatId)
            .toList(),
      );

  void _manageNewMessages(List<MessageDto> messageDtos) {
    if (messageDtos.isNotEmpty) {
      final List<Message> messages =
          messageDtos.map(mapMessageFromDto).toList();
      addOrUpdateEntities(messages);
    }
  }
}
