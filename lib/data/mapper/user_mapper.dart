import 'package:firebase/firebase.dart';

import '../../domain/additional_model/settings.dart';
import '../entity/user.dart';
import 'account_type_mapper.dart';
import 'gender_mapper.dart';

User mapUserFromDto({required UserDto userDto, required Settings settings}) =>
    User(
      accountType: mapAccountTypeFromDto(userDto.accountType),
      id: userDto.id,
      gender: mapGenderFromDto(userDto.gender),
      name: userDto.name,
      surname: userDto.surname,
      email: userDto.email,
      dateOfBirth: userDto.dateOfBirth,
      settings: settings,
      coachId: userDto.coachId,
    );

UserDto mapUserToDto({required User user}) => UserDto(
      id: user.id,
      accountType: mapAccountTypeToDto(user.accountType),
      gender: mapGenderToDto(user.gender),
      name: user.name,
      surname: user.surname,
      email: user.email,
      dateOfBirth: user.dateOfBirth,
      coachId: user.coachId,
    );
