import '../../domain/entity/person.dart';

extension PersonFormatter on Person {
  String toUIFormat() => '$name $surname ($email)';
}
