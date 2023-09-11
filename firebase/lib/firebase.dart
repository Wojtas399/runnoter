import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

export 'model/activities_settings_dto.dart';
export 'model/activity_status_dto.dart';
export 'model/appearance_settings_dto.dart';
export 'model/auth_provider.dart';
export 'model/blood_parameter.dart';
export 'model/blood_parameter_norm_dto.dart';
export 'model/blood_parameter_result_dto.dart';
export 'model/blood_test_dto.dart';
export 'model/chat_dto.dart';
export 'model/coaching_request_dto.dart';
export 'model/firebase_exception.dart';
export 'model/health_measurement_dto.dart';
export 'model/message_dto.dart';
export 'model/pace_dto.dart';
export 'model/race_dto.dart';
export 'model/user_dto.dart';
export 'model/workout_dto.dart';
export 'model/workout_stage_dto.dart';
export 'service/firebase_activities_settings_service.dart';
export 'service/firebase_appearance_settings_service.dart';
export 'service/firebase_auth_service.dart';
export 'service/firebase_blood_test_service.dart';
export 'service/firebase_chat_service.dart';
export 'service/firebase_coaching_request_service.dart';
export 'service/firebase_health_measurement_service.dart';
export 'service/firebase_message_service.dart';
export 'service/firebase_race_service.dart';
export 'service/firebase_storage_service.dart';
export 'service/firebase_user_service.dart';
export 'service/firebase_workout_service.dart';

Future<void> initializeFirebaseApp() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
