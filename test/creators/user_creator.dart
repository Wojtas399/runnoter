import 'package:runnoter/domain/entity/settings.dart';
import 'package:runnoter/domain/entity/user.dart';

import 'settings_creator.dart';

User createUser({
  String id = '',
  AccountType accountType = AccountType.runner,
  Gender gender = Gender.male,
  String name = '',
  String surname = '',
  String email = '',
  Settings? settings,
  String? coachId,
  List<String>? clientIds,
}) =>
    User(
      id: id,
      accountType: accountType,
      gender: gender,
      name: name,
      surname: surname,
      email: email,
      settings: settings ?? createSettings(),
      coachId: coachId,
      clientIds: clientIds,
    );
