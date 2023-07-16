import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import 'app.dart';
import 'presentation/config/body_sizes.dart';
import 'presentation/config/navigation/router.dart';
import 'presentation/config/screen_sizes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebaseApp();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  GetIt.I.registerSingleton<AppRouter>(AppRouter());
  GetIt.I.registerSingleton<ScreenSizes>(ScreenSizes());
  GetIt.I.registerSingleton<BodySizes>(BodySizes());
  runApp(const App());
}
