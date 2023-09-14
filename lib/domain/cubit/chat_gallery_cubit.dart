import 'dart:async';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dependency_injection.dart';
import '../entity/message.dart';
import '../repository/message_repository.dart';

class ChatGalleryCubit extends Cubit<List<Uint8List>?> {
  final MessageRepository _messageRepository;
  final String _chatId;
  StreamSubscription<List<Uint8List>?>? _imagesListener;

  ChatGalleryCubit({required String chatId})
      : _messageRepository = getIt<MessageRepository>(),
        _chatId = chatId,
        super(null);

  @override
  Future<void> close() {
    _imagesListener?.cancel();
    return super.close();
  }

  void initialize() {
    _imagesListener ??= _messageRepository
        .getMessagesForChat(chatId: _chatId)
        .map(_extractImageBytesFromMessages)
        .listen(emit);
  }

  List<Uint8List> _extractImageBytesFromMessages(List<Message> messages) {
    final imageBytesFromMessages = messages.map(
      _sortMessageImagesByOrderAndExtractBytes,
    );
    return [
      for (final messageImageBytes in imageBytesFromMessages)
        ...messageImageBytes
    ];
  }

  List<Uint8List> _sortMessageImagesByOrderAndExtractBytes(Message message) {
    final List<MessageImage> sortedImages = [...message.images];
    sortedImages.sortBy<num>((MessageImage image) => image.order);
    return sortedImages.map((image) => image.bytes).toList();
  }
}
