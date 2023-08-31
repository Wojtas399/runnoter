import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/use_case/load_chat_id_use_case.dart';

class MockLoadChatIdUseCase extends Mock implements LoadChatIdUseCase {
  void mock({String? chatId}) {
    when(
      () => execute(
        user1Id: any(named: 'user1Id'),
        user2Id: any(named: 'user2Id'),
      ),
    ).thenAnswer((_) => Future.value(chatId));
  }
}
