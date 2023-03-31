import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String id = 'u1';
  const String name = 'Jack';
  const String surname = 'Gadovsky';
  const UserDto userDto = UserDto(
    id: id,
    name: name,
    surname: surname,
  );
  final Map<String, dynamic> userJson = {
    'name': name,
    'surname': surname,
  };

  test(
    'from firestore, '
    'should map json to dto model',
    () {
      final UserDto dto = UserDto.fromJson(id, userJson);

      expect(dto, userDto);
    },
  );

  test(
    'to json, '
    'should map dto model to json',
    () {
      final Map<String, dynamic> json = userDto.toJson();

      expect(json, userJson);
    },
  );
}
