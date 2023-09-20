import 'package:collection/collection.dart';

import '../entity/message_image.dart';

extension MessageImagesExtensions on List<MessageImage> {
  sortByOrder() {
    final List<MessageImage> sortedImages = [...this];
    sortedImages.sortBy<num>((image) => image.order);
    return sortedImages;
  }
}
