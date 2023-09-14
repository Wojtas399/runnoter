import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/cubit/chat_gallery/chat_gallery_state.dart';

void main() {
  late ChatGalleryState state;

  setUp(() => state = const ChatGalleryState());

  test(
    'copy with images, '
    'should set new value or should copy current value if new value is null',
    () {
      final List<Uint8List> expected = [Uint8List(1), Uint8List(2)];

      state = state.copyWith(images: expected);
      final state2 = state.copyWith();

      expect(state.images, expected);
      expect(state2.images, expected);
    },
  );

  test(
    'copy with selectedImage, '
    'should set new value or should copy current value if new value is null',
    () {
      final Uint8List expected = Uint8List(1);

      state = state.copyWith(selectedImage: expected);
      final state2 = state.copyWith();

      expect(state.selectedImage, expected);
      expect(state2.selectedImage, expected);
    },
  );
}
