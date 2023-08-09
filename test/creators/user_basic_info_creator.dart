import 'package:runnoter/domain/additional_model/user_basic_info.dart';
import 'package:runnoter/domain/entity/user.dart';

UserBasicInfo createUserBasicInfo({
  String id = '',
  Gender gender = Gender.male,
  String name = '',
  String surname = '',
  String email = '',
}) =>
    UserBasicInfo(
      id: id,
      gender: gender,
      name: name,
      surname: surname,
      email: email,
    );
