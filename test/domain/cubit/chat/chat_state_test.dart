import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/cubit/chat/chat_cubit.dart';
import 'package:runnoter/domain/entity/message.dart';

import '../../../creators/message_creator.dart';

void main() {
  late ChatState state;

  setUp(
    () => state = const ChatState(status: BlocStatusInitial()),
  );

  test(
    'can submit message, '
    'logged user id is null, '
    'should be false',
    () {
      state = state.copyWith(messageToSend: 'message');

      expect(state.canSubmitMessage, false);
    },
  );

  test(
    'can submit message, '
    'logged user id empty string, '
    'should be false',
    () {
      state = state.copyWith(loggedUserId: '', messageToSend: 'message');

      expect(state.canSubmitMessage, false);
    },
  );

  test(
    'can submit message, '
    'message to send is null, '
    'should be false',
    () {
      state = state.copyWith(loggedUserId: 'u1');

      expect(state.canSubmitMessage, false);
    },
  );

  test(
    'can submit message, '
    'message to send is empty string, '
    'should be false',
    () {
      state = state.copyWith(loggedUserId: 'u1', messageToSend: '');

      expect(state.canSubmitMessage, false);
    },
  );

  test(
    'can submit message, '
    'logged user id and message to send are not empty string, '
    'should be true',
    () {
      state = state.copyWith(loggedUserId: 'u1', messageToSend: 'message');

      expect(state.canSubmitMessage, true);
    },
  );

  test(
    'copy with status, '
    'should assign complete status if new value is null',
    () {
      const BlocStatus expected = BlocStatusLoading();

      state = state.copyWith(status: expected);
      final state2 = state.copyWith();

      expect(state.status, expected);
      expect(state2.status, const BlocStatusComplete());
    },
  );

  test(
    'copy with loggedUserId, '
    'should copy current value if new value is null',
    () {
      const String expected = 'u1';

      state = state.copyWith(loggedUserId: expected);
      final state2 = state.copyWith();

      expect(state.loggedUserId, expected);
      expect(state2.loggedUserId, expected);
    },
  );

  test(
    'copy with senderFullName, '
    'should copy current value if new value is null',
    () {
      const String expected = 'sender full name';

      state = state.copyWith(senderFullName: expected);
      final state2 = state.copyWith();

      expect(state.senderFullName, expected);
      expect(state2.senderFullName, expected);
    },
  );

  test(
    'copy with recipientFullName, '
    'should copy current value if new value is null',
    () {
      const String expected = 'recipient full name';

      state = state.copyWith(recipientFullName: expected);
      final state2 = state.copyWith();

      expect(state.recipientFullName, expected);
      expect(state2.recipientFullName, expected);
    },
  );

  test(
    'copy with messagesFromLatest, '
    'should copy current value if new value is null',
    () {
      final List<Message> expected = [
        createMessage(id: 'm1'),
        createMessage(id: 'm2'),
      ];

      state = state.copyWith(messagesFromLatest: expected);
      final state2 = state.copyWith();

      expect(state.messagesFromLatest, expected);
      expect(state2.messagesFromLatest, expected);
    },
  );

  test(
    'copy with messageToSend, '
    'should copy current value if new value is null',
    () {
      const String expected = 'message';

      state = state.copyWith(messageToSend: expected);
      final state2 = state.copyWith();

      expect(state.messageToSend, expected);
      expect(state2.messageToSend, expected);
    },
  );

  test(
    'copy with messageToSendAsNull, '
    'should set value of messageToSend as null if set to true',
    () {
      const String messageToSend = 'message';

      state = state.copyWith(messageToSend: messageToSend);
      final state2 = state.copyWith(messageToSendAsNull: true);

      expect(state.messageToSend, messageToSend);
      expect(state2.messageToSend, null);
    },
  );
}
