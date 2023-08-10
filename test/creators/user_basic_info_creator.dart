import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/entity/user_basic_info.dart';

UserBasicInfo createUserBasicInfo({
  String id = '',
  Gender gender = Gender.male,
  String name = '',
  String surname = '',
  String email = '',
  String? coachId,
}) =>
    UserBasicInfo(
      id: id,
      gender: gender,
      name: name,
      surname: surname,
      email: email,
      coachId: coachId,
    );
