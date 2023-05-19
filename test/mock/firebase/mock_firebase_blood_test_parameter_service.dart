import 'package:firebase/model/blood_test_parameter_dto.dart';
import 'package:firebase/service/firebase_blood_test_parameter_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseBloodTestParameterService extends Mock
    implements FirebaseBloodTestParameterService {
  void mockLoadAllParameters({
    List<BloodTestParameterDto>? parameterDtos,
  }) {
    when(
      () => loadAllParameters(),
    ).thenAnswer((invocation) => Future.value(parameterDtos));
  }
}
