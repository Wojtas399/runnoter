import 'package:runnoter/domain/entity/person.dart';
import 'package:runnoter/domain/entity/user.dart';

Person createPerson({
  String id = '',
  Gender gender = Gender.male,
  String name = '',
  String surname = '',
  String email = '',
  String? coachId,
}) =>
    Person(
      id: id,
      gender: gender,
      name: name,
      surname: surname,
      email: email,
      coachId: coachId,
    );
