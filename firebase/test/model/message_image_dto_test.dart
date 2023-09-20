import 'package:firebase/model/message_image_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'i1';
  const String messageId = ' m1';
  final DateTime sendDateTime = DateTime(2023, 1, 10);
  const int order = 1;

  test(
    'from json, '
    'should map json to dto model',
    () {
      final Map<String, dynamic> json = {
        'messageId': messageId,
        'sendTimestamp': sendDateTime.millisecondsSinceEpoch,
        'order': order
      };
      final MessageImageDto expectedDto = MessageImageDto(
        id: id,
        messageId: messageId,
        sendDateTime: sendDateTime,
        order: order,
      );

      final MessageImageDto dto = MessageImageDto.fromJson(
        messageImageId: id,
        json: json,
      );

      expect(dto, expectedDto);
    },
  );

  test(
    'to json, '
    'should map dto model to json',
    () {
      final MessageImageDto dto = MessageImageDto(
        id: id,
        messageId: messageId,
        sendDateTime: sendDateTime,
        order: order,
      );
      final Map<String, dynamic> expectedJson = {
        'messageId': messageId,
        'sendTimestamp': sendDateTime.millisecondsSinceEpoch,
        'order': order
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );
}
