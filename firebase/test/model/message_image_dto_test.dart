import 'package:firebase/model/message_image_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const int order = 1;
  const String fileName = 'img.jpg';

  test(
    'from json, '
    'should map json to dto model',
    () {
      final Map<String, dynamic> json = {
        'order': order,
        'fileName': fileName,
      };
      const MessageImageDto expectedDto = MessageImageDto(
        order: order,
        fileName: fileName,
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
        order: order,
        fileName: fileName,
      );
      final Map<String, dynamic> expectedJson = {
        'order': order,
        'fileName': fileName,
      };

      final Map<String, dynamic> json = dto.toJson();

      expect(json, expectedJson);
    },
  );
}
