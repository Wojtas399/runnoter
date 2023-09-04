import 'package:runnoter/domain/additional_model/settings.dart';
import 'package:runnoter/domain/entity/user.dart';

import 'settings_creator.dart';

User createUser({
  String id = '',
  AccountType accountType = AccountType.runner,
  Gender gender = Gender.male,
  String name = '',
  String surname = '',
  String email = '',
  DateTime? dateOfBirth,
  Settings? settings,
  String? coachId,
}) =>
    User(
      id: id,
      accountType: accountType,
      gender: gender,
      name: name,
      surname: surname,
      email: email,
      dateOfBirth: dateOfBirth ?? DateTime(2023),
      settings: settings ?? createSettings(),
      coachId: coachId,
    );
