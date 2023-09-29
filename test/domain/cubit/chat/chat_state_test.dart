import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/cubit_status.dart';
import 'package:runnoter/domain/cubit/chat/chat_cubit.dart';
import 'package:runnoter/domain/entity/message.dart';

void main() {
  late ChatState state;

  setUp(
    () => state = const ChatState(status: CubitStatusInitial()),
  );

  test(
    'can submit message, '
    'message to send is null and there are no images to send, '
    'should be false',
    () {
      state = state.copyWith();

      expect(state.canSubmitMessage, false);
    },
  );

  test(
    'can submit message, '
    'message to send is not null and not empty'
    'should be true',
    () {
      state = state.copyWith(messageToSend: 'message');

      expect(state.canSubmitMessage, true);
    },
  );

  test(
    'can submit message, '
    'there are images to send'
    'should be true',
    () {
      state = state.copyWith(imagesToSend: [Uint8List(1)]);

      expect(state.canSubmitMessage, true);
    },
  );

  test(
    'copy with status, '
    'should set new status or '
    'should assign complete status if new value is null',
    () {
      const CubitStatus expected = CubitStatusLoading();

      state = state.copyWith(status: expected);
      final state2 = state.copyWith();

      expect(state.status, expected);
      expect(state2.status, const CubitStatusComplete());
    },
  );

  test(
    'copy with recipientFullName, '
    'should set new value or '
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
    'copy with isRecipientTyping, '
    'should set new value or '
    'should copy current value if new value is null',
    () {
      const bool expected = true;

      state = state.copyWith(isRecipientTyping: expected);
      final state2 = state.copyWith();

      expect(state.isRecipientTyping, expected);
      expect(state2.isRecipientTyping, expected);
    },
  );

  test(
    'copy with messagesFromLatest, '
    'should set new value or '
    'should copy current value if new value is null',
    () {
      final List<ChatMessage> expected = [
        ChatMessage(
          id: 'm1',
          status: MessageStatus.read,
          hasBeenSentByLoggedUser: true,
          dateTime: DateTime(2023, 1, 1),
        ),
        ChatMessage(
          id: 'm2',
          status: MessageStatus.read,
          hasBeenSentByLoggedUser: false,
          dateTime: DateTime(2023, 1, 2),
        ),
      ];

      state = state.copyWith(messagesFromLatest: expected);
      final state2 = state.copyWith();

      expect(state.messagesFromLatest, expected);
      expect(state2.messagesFromLatest, expected);
    },
  );

  test(
    'copy with messageToSend, '
    'should set new value or '
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

  test(
    'copy with imagesToSend, '
    'should set new value or '
    'should copy current value if new value is null',
    () {
      final List<Uint8List> expected = [Uint8List(1), Uint8List(2)];

      state = state.copyWith(imagesToSend: expected);
      final state2 = state.copyWith();

      expect(state.imagesToSend, expected);
      expect(state2.imagesToSend, expected);
    },
  );
}
