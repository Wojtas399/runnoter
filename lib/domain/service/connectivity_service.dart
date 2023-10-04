import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  Stream<bool> get connectivityStatus$ async* {
    yield await hasDeviceInternetConnection();
    await for (final conResult in Connectivity().onConnectivityChanged) {
      yield conResult != ConnectivityResult.none;
    }
  }

  Future<bool> hasDeviceInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
