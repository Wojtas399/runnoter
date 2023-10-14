import 'package:runnoter/data/entity/person.dart';
import 'package:runnoter/domain/entity/user.dart';

Person createPerson({
  String id = '',
  AccountType accountType = AccountType.runner,
  Gender gender = Gender.male,
  String name = '',
  String surname = '',
  String email = '',
  DateTime? dateOfBirth,
  String? coachId,
}) =>
    Person(
      id: id,
      accountType: accountType,
      gender: gender,
      name: name,
      surname: surname,
      email: email,
      dateOfBirth: dateOfBirth ?? DateTime(2023),
      coachId: coachId,
    );
