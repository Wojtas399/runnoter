import 'package:firebase/firebase.dart';

UserDto createUserDto({
  String id = '',
  Gender gender = Gender.male,
  String name = '',
  String surname = '',
  String email = '',
  String? coachId,
  List<String>? clientIds,
}) =>
    UserDto(
      id: id,
      gender: gender,
      name: name,
      surname: surname,
      email: email,
      coachId: coachId,
      clientIds: clientIds,
    );
