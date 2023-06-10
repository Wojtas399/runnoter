import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/service/list_service.dart';

void main() {
  test(
    'are lists equal, '
    'lists have different lengths, '
    'should return false',
    () {
      final List<String> list1 = ['1', '2', '3'];
      final List<String> list2 = ['1', '2'];

      final bool result = areListsEqual(list1, list2);

      expect(result, false);
    },
  );

  test(
    'are lists equal, '
    'lists have different items, '
    'should return false',
    () {
      final List<String> list1 = ['1', '2', '3'];
      final List<String> list2 = ['4', '5', '6'];

      final bool result = areListsEqual(list1, list2);

      expect(result, false);
    },
  );

  test(
    'are lists equal, '
    'lists have the same items but in different order, '
    'should return false',
    () {
      final List<String> list1 = ['1', '2', '3'];
      final List<String> list2 = ['2', '1', '3'];

      final bool result = areListsEqual(list1, list2);

      expect(result, false);
    },
  );

  test(
    'are lists equal, '
    'lists have the same items in the same order, '
    'should return true',
    () {
      final List<String> list1 = ['1', '2', '3'];
      final List<String> list2 = ['1', '2', '3'];

      final bool result = areListsEqual(list1, list2);

      expect(result, true);
    },
  );
}
