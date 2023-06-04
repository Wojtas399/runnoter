import 'package:collection/collection.dart';

bool areListsEqual(List list1, List list2) {
  return const ListEquality().equals(list1, list2);
}
