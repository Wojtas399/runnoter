import 'package:runnoter/domain/entity/settings.dart';
import 'package:runnoter/domain/entity/user.dart';

import 'settings_creator.dart';

User createUser({
  String id = '',
  Gender gender = Gender.male,
  String name = '',
  String surname = '',
  Settings? settings,
}) =>
    //TODO: Implement for all types
    Runner(
      id: id,
      gender: gender,
      name: name,
      surname: surname,
      settings: settings ?? createSettings(),
    );
