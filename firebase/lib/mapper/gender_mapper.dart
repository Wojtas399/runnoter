import '../firebase.dart';

Gender mapGenderFromString(String genderStr) => Gender.values.byName(genderStr);

String mapGenderToString(Gender gender) => gender.name;
