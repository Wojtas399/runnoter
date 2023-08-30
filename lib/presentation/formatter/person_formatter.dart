import '../../domain/entity/person.dart';

extension PersonFormatter on Person {
  String toFullName() => '$name $surname';

  String toFullNameWithEmail() => '$name $surname ($email)';
}
