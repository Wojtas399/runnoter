library firebase;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'mapper/firebase_auth_exception_code_mapper.dart';
import 'model/firebase_auth_exception_code.dart';

part 'firebase_collections.dart';
part 'model/dto/user_dto.dart';
part 'service/firebase_auth_service.dart';
part 'service/firebase_user_service.dart';

Future<void> initializeFirebaseApp() async {
  await Firebase.initializeApp();
}
