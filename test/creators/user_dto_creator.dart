import 'package:firebase/firebase.dart';

UserDto createUserDto({
  String id = '',
  Gender gender = Gender.male,
  String name = '',
  String surname = '',
  String? coachId,
  List<String>? clientIds,
}) =>
    UserDto(
      id: id,
      gender: gender,
      name: name,
      surname: surname,
      coachId: coachId,
      clientIds: clientIds,
    );
