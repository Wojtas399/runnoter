import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/interface/repository/chat_repository.dart';
import 'package:runnoter/data/interface/repository/message_image_repository.dart';
import 'package:runnoter/domain/repository/message_repository.dart';
import 'package:runnoter/domain/use_case/delete_chat_use_case.dart';

import '../../mock/domain/repository/mock_chat_repository.dart';
import '../../mock/domain/repository/mock_message_image_repository.dart';
import '../../mock/domain/repository/mock_message_repository.dart';

void main() {
  final chatRepository = MockChatRepository();
  final messageRepository = MockMessageRepository();
  final messageImageRepository = MockMessageImageRepository();

  setUpAll(() {
    GetIt.I.registerSingleton<ChatRepository>(chatRepository);
    GetIt.I.registerSingleton<MessageRepository>(messageRepository);
    GetIt.I.registerSingleton<MessageImageRepository>(messageImageRepository);
  });

  tearDown(() {
    reset(chatRepository);
    reset(messageRepository);
    reset(messageImageRepository);
  });

  test(
    'should call message image repository method to delete images from chat, '
    'should call message repository method to delete all messages from chat, '
    'should call chat repository method to delete chat',
    () async {
      const String chatId = 'c1';
      messageImageRepository.mockDeleteAllImagesFromChat();
      messageRepository.mockDeleteAllMessagesFromChat();
      chatRepository.mockDeleteChat();
      final useCase = DeleteChatUseCase();

      await useCase.execute(chatId: chatId);

      verify(
        () => messageImageRepository.deleteAllImagesFromChat(chatId: chatId),
      ).called(1);
      verify(
        () => messageRepository.deleteAllMessagesFromChat(chatId: chatId),
      ).called(1);
      verify(() => chatRepository.deleteChat(chatId: chatId)).called(1);
    },
  );
}
