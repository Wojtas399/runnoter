import 'package:runnoter/data/model/user.dart';

import 'user_settings_creator.dart';

User createUser({
  String id = '',
  AccountType accountType = AccountType.runner,
  Gender gender = Gender.male,
  String name = '',
  String surname = '',
  String email = '',
  DateTime? dateOfBirth,
  UserSettings? settings,
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
      settings: settings ?? createUserSettings(),
      coachId: coachId,
    );
