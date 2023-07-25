import 'package:firebase/firebase.dart' as firebase;

import '../../domain/entity/user.dart';

Gender mapGenderFromDto(firebase.Gender dtoGender) => switch (dtoGender) {
      firebase.Gender.male => Gender.male,
      firebase.Gender.female => Gender.female,
    };

firebase.Gender mapGenderToDto(Gender gender) => switch (gender) {
      Gender.male => firebase.Gender.male,
      Gender.female => firebase.Gender.female,
    };
