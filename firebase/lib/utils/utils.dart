import 'package:connectivity_plus/connectivity_plus.dart';

String twoDigits(int number) {
  return number.toString().padLeft(2, '0');
}

Future<void> asyncOrSyncCall(Future<void> Function() func) async {
  if (await _isInternetConnection()) {
    await func();
  } else {
    func();
  }
}

Future<bool> _isInternetConnection() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult == ConnectivityResult.wifi ||
      connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.ethernet;
}
