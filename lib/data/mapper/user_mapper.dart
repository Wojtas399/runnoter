import 'package:firebase/firebase.dart';

import '../../domain/additional_model/settings.dart';
import '../../domain/entity/user.dart';
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
      dateOfBirth: DateTime(2023), //TODO
      settings: settings,
      coachId: userDto.coachId,
    );
