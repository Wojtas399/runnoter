import 'package:firebase/firebase.dart';
import 'package:firebase/mapper/gender_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'map gender from string, '
    'male string should be mapped to Gender.male',
    () {
      const String genderStr = 'male';
      const Gender expectedGender = Gender.male;

      final Gender gender = mapGenderFromString(genderStr);

      expect(gender, expectedGender);
    },
  );

  test(
    'map gender from string, '
    'female string should be mapped to Gender.female',
    () {
      const String genderStr = 'female';
      const Gender expectedGender = Gender.female;

      final Gender gender = mapGenderFromString(genderStr);

      expect(gender, expectedGender);
    },
  );

  test(
    'map gender to string, '
    'Gender.male should be mapped to male string',
    () {
      const Gender gender = Gender.male;
      const String expectedGenderStr = 'male';

      final String genderStr = mapGenderToString(gender);

      expect(genderStr, expectedGenderStr);
    },
  );

  test(
    'map gender to string, '
    'Gender.female should be mapped to female string',
    () {
      const Gender gender = Gender.female;
      const String expectedGenderStr = 'female';

      final String genderStr = mapGenderToString(gender);

      expect(genderStr, expectedGenderStr);
    },
  );
}
