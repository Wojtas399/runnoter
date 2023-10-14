import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/entity/message.dart';
import 'package:runnoter/data/mapper/message_status_mapper.dart';

void main() {
  test(
    'map message status from dto, '
    'dto MessageStatus.sent should be mapped to domain MessageStatus.sent',
    () {
      const firebase.MessageStatus dtoStatus = firebase.MessageStatus.sent;
      const MessageStatus expectedStatus = MessageStatus.sent;

      final MessageStatus status = mapMessageStatusFromDto(dtoStatus);

      expect(status, expectedStatus);
    },
  );

  test(
    'map message status from dto, '
    'dto MessageStatus.read should be mapped to domain MessageStatus.read',
    () {
      const firebase.MessageStatus dtoStatus = firebase.MessageStatus.read;
      const MessageStatus expectedStatus = MessageStatus.read;

      final MessageStatus status = mapMessageStatusFromDto(dtoStatus);

      expect(status, expectedStatus);
    },
  );

  test(
    'map message status to dto, '
    'domain MessageStatus.sent should be mapped to dto MessageStatus.sent',
    () {
      const MessageStatus status = MessageStatus.sent;
      const firebase.MessageStatus expectedDtoStatus =
          firebase.MessageStatus.sent;

      final firebase.MessageStatus dtoStatus = mapMessageStatusToDto(status);

      expect(dtoStatus, expectedDtoStatus);
    },
  );

  test(
    'map message status to dto, '
    'domain MessageStatus.read should be mapped to dto MessageStatus.read',
    () {
      const MessageStatus status = MessageStatus.read;
      const firebase.MessageStatus expectedDtoStatus =
          firebase.MessageStatus.read;

      final firebase.MessageStatus dtoStatus = mapMessageStatusToDto(status);

      expect(dtoStatus, expectedDtoStatus);
    },
  );
}
