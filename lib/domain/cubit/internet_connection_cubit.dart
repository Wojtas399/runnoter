import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InternetConnectionCubit extends Cubit<bool?> {
  StreamSubscription<bool?>? _listener;

  InternetConnectionCubit() : super(null);

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    final Connectivity connectivity = Connectivity();
    final ConnectivityResult result = await connectivity.checkConnectivity();
    emit(result != ConnectivityResult.none);
    _listener = connectivity.onConnectivityChanged
        .map((ConnectivityResult result) => result != ConnectivityResult.none)
        .listen(emit);
  }
}
