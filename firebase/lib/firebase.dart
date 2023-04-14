library firebase;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'model/appearance_settings_dto.dart';
import 'model/user_dto.dart';
import 'model/workout_dto.dart';
import 'model/workout_settings_dto.dart';

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

part 'firebase_collections.dart';
part 'service/firebase_user_service.dart';
part 'service/firebase_workout_settings_service.dart';

Future<void> initializeFirebaseApp() async {
  await Firebase.initializeApp();
}
