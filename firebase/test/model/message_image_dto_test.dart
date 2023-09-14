import 'package:firebase/model/message_image_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'i1';
  const int order = 1;

  test(
    'from json, '
    'should map json to dto model',
    () {
      final Map<String, dynamic> json = {
        'id': id,
        'order': order,
      };
      const MessageImageDto expectedDto = MessageImageDto(
        id: id,
        order: order,
      );

      final MessageImageDto dto = MessageImageDto.fromJson(json);

      expect(dto, expectedDto);
    },
  );

  test(
    'to json, '
    'should map dto model to json',
    () {
      const MessageImageDto dto = MessageImageDto(
        id: id,
        order: order,
      );
      final Map<String, dynamic> expectedJson = {
        'id': id,
        'order': order,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );
}
