import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/chat/chat_state.dart';
import 'package:runnoter/domain/entity/chat.dart';

import '../../../creators/message_creator.dart';

void main() {
  late ChatState state;

  setUp(
    () => state = const ChatState(status: BlocStatusInitial()),
  );

  test(
    'copy with status',
    () {
      const BlocStatus expected = BlocStatusLoading();

      state = state.copyWith(status: expected);
      final state2 = state.copyWith();

      expect(state.status, expected);
      expect(state2.status, const BlocStatusComplete());
    },
  );

  test(
    'copy with senderFullName',
    () {
      const String expected = 'sender full name';

      state = state.copyWith(senderFullName: expected);
      final state2 = state.copyWith();

      expect(state.senderFullName, expected);
      expect(state2.senderFullName, expected);
    },
  );

  test(
    'copy with recipientFullName',
    () {
      const String expected = 'recipient full name';

      state = state.copyWith(recipientFullName: expected);
      final state2 = state.copyWith();

      expect(state.recipientFullName, expected);
      expect(state2.recipientFullName, expected);
    },
  );

  test(
    'copy with messages',
    () {
      final List<Message> expected = [
        createMessage(id: 'm1'),
        createMessage(id: 'm2'),
      ];

      state = state.copyWith(messages: expected);
      final state2 = state.copyWith();

      expect(state.messages, expected);
      expect(state2.messages, expected);
    },
  );
}
