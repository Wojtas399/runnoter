library firebase;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'mapper/firebase_auth_exception_code_mapper.dart';
import 'mapper/language_mapper.dart';
import 'mapper/theme_mode_mapper.dart';

part 'firebase_collections.dart';
part 'model/appearance_settings_dto.dart';
part 'model/distance_unit.dart';
part 'model/firebase_auth_exception_code.dart';
part 'model/language.dart';
part 'model/pace_unit.dart';
part 'model/theme_mode.dart';
part 'model/user_dto.dart';
part 'service/firebase_auth_service.dart';
part 'service/firebase_user_service.dart';

Future<void> initializeFirebaseApp() async {
  await Firebase.initializeApp();
}
