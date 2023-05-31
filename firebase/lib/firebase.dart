import 'package:firebase_core/firebase_core.dart';

export 'model/appearance_settings_dto.dart';
export 'model/blood_parameter.dart';
export 'model/blood_parameter_norm_dto.dart';
export 'model/blood_parameter_result_dto.dart';
export 'model/blood_test_dto.dart';
export 'model/firebase_auth_exception_code.dart';
export 'model/health_measurement_dto.dart';
export 'model/pace_dto.dart';
export 'model/user_dto.dart';
export 'model/workout_dto.dart';
export 'model/workout_settings_dto.dart';
export 'model/workout_stage_dto.dart';
export 'model/workout_status_dto.dart';
export 'service/firebase_appearance_settings_service.dart';
export 'service/firebase_auth_service.dart';
export 'service/firebase_blood_test_service.dart';
export 'service/firebase_health_measurement_service.dart';
export 'service/firebase_user_service.dart';
export 'service/firebase_workout_settings_service.dart';

Future<void> initializeFirebaseApp() async {
  await Firebase.initializeApp();
}
