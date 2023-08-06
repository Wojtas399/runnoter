import 'package:runnoter/domain/entity/settings.dart';
import 'package:runnoter/domain/entity/user.dart';

import 'settings_creator.dart';

Runner createRunner({
  String id = '',
  Gender gender = Gender.male,
  String name = '',
  String surname = '',
  Settings? settings,
  String? coachId,
}) =>
    Runner(
      id: id,
      gender: gender,
      name: name,
      surname: surname,
      settings: settings ?? createSettings(),
      coachId: coachId,
    );

Coach createCoach({
  String id = '',
  Gender gender = Gender.male,
  String name = '',
  String surname = '',
  Settings? settings,
  String? coachId,
  List<String> idsOfRunners = const [],
}) =>
    Coach(
      id: id,
      gender: gender,
      name: name,
      surname: surname,
      settings: settings ?? createSettings(),
      coachId: coachId,
      idsOfRunners: idsOfRunners,
    );
