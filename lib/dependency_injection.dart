import 'package:firebase/firebase.dart';
import 'package:get_it/get_it.dart';

import 'data/service_impl/auth_service_impl.dart';
import 'domain/service/auth_service.dart';
import 'presentation/config/body_sizes.dart';
import 'presentation/config/navigation/router.dart';
import 'presentation/config/screen_sizes.dart';

final getIt = GetIt.I;

void setUpGetIt() {
  getIt.registerLazySingleton(() => AppRouter());
  getIt.registerLazySingleton(() => ScreenSizes());
  getIt.registerLazySingleton(() => BodySizes());
  getIt.registerLazySingleton<AuthService>(
    () => AuthServiceImpl(
      firebaseAuthService: FirebaseAuthService(),
    ),
  );
}
