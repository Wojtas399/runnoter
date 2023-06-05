import 'package:runnoter/domain/entity/settings.dart';
import 'package:runnoter/domain/entity/user.dart';

import 'settings_creator.dart';

User createUser({
  String id = '',
  String name = '',
  String surname = '',
  Settings? settings,
}) {
  return User(
    id: id,
    name: name,
    surname: surname,
    settings: settings ?? createSettings(),
  );
}
