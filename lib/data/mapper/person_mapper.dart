import 'package:firebase/firebase.dart';

import '../../domain/entity/person.dart';
import 'gender_mapper.dart';

Person mapPersonFromUserDto(UserDto userDto) => Person(
      id: userDto.id,
      gender: mapGenderFromDto(userDto.gender),
      name: userDto.name,
      surname: userDto.surname,
      email: userDto.email,
      coachId: userDto.coachId,
    );
