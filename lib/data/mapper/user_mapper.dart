import 'package:firebase/model/dto/user_dto.dart';

import '../../domain/model/user.dart';

User mapUserFromDtoModel(UserDto dto) {
  return User(
    id: dto.id,
    name: dto.name,
    surname: dto.surname,
  );
}
