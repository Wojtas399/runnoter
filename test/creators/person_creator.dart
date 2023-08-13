import 'package:runnoter/domain/entity/person.dart';
import 'package:runnoter/domain/entity/user.dart';

Person createPerson({
  String id = '',
  AccountType accountType = AccountType.runner,
  Gender gender = Gender.male,
  String name = '',
  String surname = '',
  String email = '',
  String? coachId,
}) =>
    Person(
      id: id,
      accountType: accountType,
      gender: gender,
      name: name,
      surname: surname,
      email: email,
      coachId: coachId,
    );
