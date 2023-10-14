import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/entity/message_image.dart';
import 'package:runnoter/ui/feature/dialog/chat_image_preview/cubit/chat_image_preview_cubit.dart';

import '../../../../creators/message_image_creator.dart';

void main() {
  late ChatImagePreviewState state;

  setUp(() => state = const ChatImagePreviewState());

  test(
    'is selected image first one, '
    'images list is empty, '
    'should be false',
    () {
      state = state.copyWith(
        selectedImage: createMessageImage(id: 'i1'),
      );

      expect(state.isSelectedImageFirstOne, false);
    },
  );

  test(
    'is selected image first one, '
    'selected image is null, '
    'should be false',
    () {
      state = state.copyWith(
        images: [
          createMessageImage(id: 'i1'),
          createMessageImage(id: 'i2'),
        ],
      );

      expect(state.isSelectedImageFirstOne, false);
    },
  );

  test(
    'is selected image first one, '
    'selected image is not first in the list of images, '
    'should be false',
    () {
      state = state.copyWith(
        images: [
          createMessageImage(id: 'i1'),
          createMessageImage(id: 'i2'),
        ],
        selectedImage: createMessageImage(id: 'i2'),
      );

      expect(state.isSelectedImageFirstOne, false);
    },
  );

  test(
    'is selected image first one, '
    'selected image is first in the list of images, '
    'should be true',
    () {
      state = state.copyWith(
        images: [
          createMessageImage(id: 'i1'),
          createMessageImage(id: 'i2'),
        ],
        selectedImage: createMessageImage(id: 'i1'),
      );

      expect(state.isSelectedImageFirstOne, true);
    },
  );

  test(
    'is selected image last one, '
    'images list is empty, '
    'should be false',
    () {
      state = state.copyWith(
        selectedImage: createMessageImage(id: 'i1'),
      );

      expect(state.isSelectedImageLastOne, false);
    },
  );

  test(
    'is selected image last one, '
    'selected image is null, '
    'should be false',
    () {
      state = state.copyWith(
        images: [
          createMessageImage(id: 'i1'),
          createMessageImage(id: 'i2'),
        ],
      );

      expect(state.isSelectedImageLastOne, false);
    },
  );

  test(
    'is selected image last one, '
    'selected image is not last in the list of images, '
    'should be false',
    () {
      state = state.copyWith(
        images: [
          createMessageImage(id: 'i1'),
          createMessageImage(id: 'i2'),
        ],
        selectedImage: createMessageImage(id: 'i1'),
      );

      expect(state.isSelectedImageLastOne, false);
    },
  );

  test(
    'is selected image last one, '
    'selected image is last in the list of images, '
    'should be true',
    () {
      state = state.copyWith(
        images: [
          createMessageImage(id: 'i1'),
          createMessageImage(id: 'i2'),
        ],
        selectedImage: createMessageImage(id: 'i2'),
      );

      expect(state.isSelectedImageLastOne, true);
    },
  );

  test(
    'copy with images, '
    'should set new value or should copy current value if new value is null',
    () {
      final List<MessageImage> expected = [
        createMessageImage(id: 'i1'),
        createMessageImage(id: 'i2'),
      ];

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
      final MessageImage expected = createMessageImage(id: 'i1');

      state = state.copyWith(selectedImage: expected);
      final state2 = state.copyWith();

      expect(state.selectedImage, expected);
      expect(state2.selectedImage, expected);
    },
  );
}
