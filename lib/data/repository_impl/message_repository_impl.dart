import 'dart:async';
import 'dart:typed_data';

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
  final FirebaseStorageService _dbStorageService;

  MessageRepositoryImpl({super.initialData})
      : _dbMessageService = getIt<FirebaseMessageService>(),
        _dbStorageService = getIt<FirebaseStorageService>();

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
  Future<void> addMessageToChat({
    required String chatId,
    required String senderId,
    required DateTime dateTime,
    String? text,
    List<MessageImage> images = const [],
  }) async {
    final List<MessageImageDto> uploadedImages =
        await _uploadImagesToDb(chatId, images);
    final addedMessageDto = await _dbMessageService.addMessageToChat(
      chatId: chatId,
      senderId: senderId,
      dateTime: dateTime,
      text: text,
      images: uploadedImages,
    );
    if (addedMessageDto != null) {
      final Message addedMessage = mapMessageFromDto(addedMessageDto, images);
      addEntity(addedMessage);
    }
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
      messages.add(await _loadImagesFromDbForMessage(messageDto));
    }
    return messages;
  }

  Future<Message> _loadImagesFromDbForMessage(MessageDto messageDto) async {
    final List<MessageImage> loadedImages = [];
    for (final imageDto in messageDto.images) {
      final Uint8List? imageBytes = await _dbStorageService.loadChatImage(
        chatId: messageDto.chatId,
        imageFileName: imageDto.fileName,
      );
      if (imageBytes != null) {
        loadedImages.add(
          MessageImage(order: imageDto.order, bytes: imageBytes),
        );
      }
    }
    return mapMessageFromDto(messageDto, loadedImages);
  }

  Future<List<MessageImageDto>> _uploadImagesToDb(
    String chatId,
    List<MessageImage> images,
  ) async {
    final List<MessageImageDto> uploadedImages = [];
    for (final image in images) {
      final String? imageFileName = await _dbStorageService.uploadChatImage(
        chatId: chatId,
        imageBytes: image.bytes,
      );
      if (imageFileName != null) {
        uploadedImages.add(
          MessageImageDto(order: image.order, fileName: imageFileName),
        );
      }
    }
    return uploadedImages;
  }
}
