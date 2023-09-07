import 'package:firebase/firebase.dart';

import '../../domain/entity/person.dart';
import 'account_type_mapper.dart';
import 'gender_mapper.dart';

Person mapPersonFromUserDto(UserDto userDto) => Person(
      id: userDto.id,
      accountType: mapAccountTypeFromDto(userDto.accountType),
      gender: mapGenderFromDto(userDto.gender),
      name: userDto.name,
      surname: userDto.surname,
      email: userDto.email,
      dateOfBirth: userDto.dateOfBirth,
      coachId: userDto.coachId,
    );
