import 'package:firebase/firebase.dart';
import 'package:firebase/service/firebase_blood_test_parameter_service.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/model/blood_test_parameter.dart';
import '../../domain/model/state_repository.dart';
import '../../domain/repository/blood_test_parameter_repository.dart';
import '../mapper/blood_test_parameter_mapper.dart';

class BloodTestParameterRepositoryImpl
    extends StateRepository<BloodTestParameter>
    implements BloodTestParameterRepository {
  final FirebaseBloodTestParameterService _firebaseBloodTestParameterService;

  BloodTestParameterRepositoryImpl({
    required FirebaseBloodTestParameterService
        firebaseBloodTestParameterService,
    List<BloodTestParameter>? initialState,
  })  : _firebaseBloodTestParameterService = firebaseBloodTestParameterService,
        super(
          initialData: initialState,
        );

  @override
  Stream<List<BloodTestParameter>?> getAllParameters() =>
      dataStream$.doOnListen(_loadAllParametersFromRemoteDb);

  Future<void> _loadAllParametersFromRemoteDb() async {
    final List<BloodTestParameterDto>? dtos =
        await _firebaseBloodTestParameterService.loadAllParameters();
    if (dtos != null) {
      final List<BloodTestParameter> parameters =
          dtos.map(mapBloodTestParameterFromDto).toList();
      addEntities(parameters);
    }
  }
}
