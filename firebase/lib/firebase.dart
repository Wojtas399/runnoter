library firebase;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

export 'package:firebase_auth/firebase_auth.dart';

part 'firebase_collections.dart';
part 'model/userDto.dart';
part 'service/firebase_auth_service.dart';
part 'service/firebase_user_service.dart';

Future<void> initializeFirebaseApp() async {
  await Firebase.initializeApp();
}
