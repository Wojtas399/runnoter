import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/use_case/delete_chat_use_case.dart';

class MockDeleteChatUseCase extends Mock implements DeleteChatUseCase {
  void mock() {
    when(
      () => execute(chatId: any(named: 'chatId')),
    ).thenAnswer((_) => Future.value());
  }
}
