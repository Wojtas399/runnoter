import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  Future<bool> hasDeviceInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet;
  }
}
