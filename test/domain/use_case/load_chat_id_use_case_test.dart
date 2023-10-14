import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/interface/repository/chat_repository.dart';
import 'package:runnoter/domain/use_case/load_chat_id_use_case.dart';

import '../../mock/domain/repository/mock_chat_repository.dart';

void main() {
  final chatRepository = MockChatRepository();
  late LoadChatIdUseCase useCase;
  const String user1Id = 'u1';
  const String user2Id = 'u2';

  setUpAll(() {
    GetIt.I.registerSingleton<ChatRepository>(chatRepository);
  });

  setUp(() => useCase = LoadChatIdUseCase());

  tearDown(() {
    reset(chatRepository);
  });

  test(
    'users have own chat, '
    'should return id of found chat',
    () async {
      const String foundChatId = 'c1';
      chatRepository.mockFindChatIdForUsers(chatId: foundChatId);

      final String? chatId = await useCase.execute(
        user1Id: user1Id,
        user2Id: user2Id,
      );

      expect(chatId, foundChatId);
      verify(
        () => chatRepository.findChatIdByUsers(
          user1Id: user1Id,
          user2Id: user2Id,
        ),
      ).called(1);
    },
  );

  test(
    'users do not have own chat, '
    'should create new chat and return its id',
    () async {
      const String createdChatId = 'c1';
      chatRepository.mockFindChatIdForUsers();
      chatRepository.mockCreateChatForUsers(chatId: createdChatId);

      final String? chatId = await useCase.execute(
        user1Id: user1Id,
        user2Id: user2Id,
      );

      expect(chatId, createdChatId);
      verify(
        () => chatRepository.findChatIdByUsers(
          user1Id: user1Id,
          user2Id: user2Id,
        ),
      ).called(1);
      verify(
        () => chatRepository.createChatForUsers(
          user1Id: user1Id,
          user2Id: user2Id,
        ),
      ).called(1);
    },
  );
}
