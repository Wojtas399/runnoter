import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/gender_mapper.dart';
import 'package:runnoter/data/model/user.dart';

void main() {
  test(
    'map gender from dto, '
    'Dto gender male should be mapped to domain gender male',
    () {
      const firebase.Gender dtoGender = firebase.Gender.male;
      const Gender expectedGender = Gender.male;

      final Gender gender = mapGenderFromDto(dtoGender);

      expect(gender, expectedGender);
    },
  );

  test(
    'map gender from dto, '
    'Dto gender female should be mapped to domain gender female',
    () {
      const firebase.Gender dtoGender = firebase.Gender.female;
      const Gender expectedGender = Gender.female;

      final Gender gender = mapGenderFromDto(dtoGender);

      expect(gender, expectedGender);
    },
  );

  test(
    'map gender to dto, '
    'domain gender male should be mapped to dto gender male',
    () {
      const Gender gender = Gender.male;
      const firebase.Gender expectedDtoGender = firebase.Gender.male;

      final firebase.Gender dtoGender = mapGenderToDto(gender);

      expect(dtoGender, expectedDtoGender);
    },
  );

  test(
    'map gender to dto, '
    'domain gender female should be mapped to dto gender female',
    () {
      const Gender gender = Gender.female;
      const firebase.Gender expectedDtoGender = firebase.Gender.female;

      final firebase.Gender dtoGender = mapGenderToDto(gender);

      expect(dtoGender, expectedDtoGender);
    },
  );
}
