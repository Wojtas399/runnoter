import 'package:firebase/firebase.dart';

import '../../domain/entity/user_basic_info.dart';
import 'gender_mapper.dart';

UserBasicInfo mapUserBasicInfoFromDto(UserDto userDto) => UserBasicInfo(
      id: userDto.id,
      gender: mapGenderFromDto(userDto.gender),
      name: userDto.name,
      surname: userDto.surname,
      email: userDto.email,
      coachId: userDto.coachId,
    );
