import 'package:firebase_core/firebase_core.dart';

export 'model/appearance_settings_dto.dart';
export 'model/firebase_auth_exception_code.dart';
export 'model/pace_dto.dart';
export 'model/user_dto.dart';
export 'model/workout_dto.dart';
export 'model/workout_settings_dto.dart';
export 'model/workout_stage_dto.dart';
export 'model/workout_status_dto.dart';
export 'service/firebase_appearance_settings_service.dart';
export 'service/firebase_auth_service.dart';
export 'service/firebase_user_service.dart';
export 'service/firebase_workout_settings_service.dart';

Future<void> initializeFirebaseApp() async {
  await Firebase.initializeApp();
}
