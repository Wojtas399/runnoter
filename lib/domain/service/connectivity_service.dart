import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  Stream<bool> onConnectivityStatusChanged() {
    return Connectivity().onConnectivityChanged.map(
          (connectivityResult) => connectivityResult != ConnectivityResult.none,
        );
  }

  Future<bool> hasDeviceInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
