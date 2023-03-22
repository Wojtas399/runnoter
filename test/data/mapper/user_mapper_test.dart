import 'package:firebase/model/dto/user_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/user_mapper.dart';
import 'package:runnoter/domain/model/user.dart';

void main() {
  test(
    'map user from dto model',
    () {
      const UserDto dtoModel = UserDto(
        id: 'u1',
        name: 'name',
        surname: 'surname',
      );
      const User expectedUser = User(
        id: 'u1',
        name: 'name',
        surname: 'surname',
      );

      final User user = mapUserFromDtoModel(dtoModel);

      expect(user, expectedUser);
    },
  );
}
