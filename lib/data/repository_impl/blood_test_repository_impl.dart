import 'package:firebase/firebase.dart';
import 'package:firebase/service/firebase_blood_test_parameter_service.dart';

import '../../domain/model/blood_test_parameter.dart';
import '../../domain/repository/blood_test_repository.dart';
import '../mapper/blood_test_parameter_mapper.dart';

class BloodTestRepositoryImpl implements BloodTestRepository {
  final FirebaseBloodTestParameterService _firebaseBloodTestParameterService;

  BloodTestRepositoryImpl({
    required FirebaseBloodTestParameterService
        firebaseBloodTestParameterService,
  }) : _firebaseBloodTestParameterService = firebaseBloodTestParameterService;

  @override
  Future<List<BloodTestParameter>?> loadAllParameters() async {
    final List<BloodTestParameterDto>? dtos =
        await _firebaseBloodTestParameterService.loadAllParameters();
    if (dtos != null) {
      return dtos.map(mapBloodTestParameterFromDto).toList();
    }
    return null;
  }
}
