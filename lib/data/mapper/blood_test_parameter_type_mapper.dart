import 'package:firebase/firebase.dart' as firebase;

import '../../domain/model/blood_test_parameter.dart';

BloodTestParameterType mapBloodTestParameterTypeFromDto(
  firebase.BloodTestParameterType dtoType,
) =>
    switch (dtoType) {
      firebase.BloodTestParameterType.basic => BloodTestParameterType.basic,
      firebase.BloodTestParameterType.additional =>
        BloodTestParameterType.additional,
    };
