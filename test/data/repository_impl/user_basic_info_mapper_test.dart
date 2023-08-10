import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/user_basic_info_mapper.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/entity/user_basic_info.dart';

import '../../creators/user_dto_creator.dart';

void main() {
  const String id = 'u1';
  const firebase.Gender dtoGender = firebase.Gender.male;
  const Gender gender = Gender.male;
  const String name = 'name';
  const String surname = 'surname';
  const String email = 'email@example.com';
  const String coachId = 'c1';

  test(
    'map user basic info from dto, '
    'should map UserDto model to domain UserBasicInfo model',
    () {
      final firebase.UserDto userDto = createUserDto(
        id: id,
        gender: dtoGender,
        name: name,
        surname: surname,
        email: email,
        coachId: coachId,
      );
      const UserBasicInfo expectedUserBasicInfo = UserBasicInfo(
        id: id,
        gender: gender,
        name: name,
        surname: surname,
        email: email,
        coachId: coachId,
      );

      final UserBasicInfo userBasicInfo = mapUserBasicInfoFromDto(userDto);

      expect(userBasicInfo, expectedUserBasicInfo);
    },
  );
}
