import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../dependency_injection.dart';
import '../../../domain/service/connectivity_service.dart';
import '../../component/empty_content_info_component.dart';
import '../../component/loading_info_component.dart';

@RoutePage()
class AppBaseScreen extends StatefulWidget {
  const AppBaseScreen({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AppBaseScreen> {
  late Future<bool> _isInternetConnection;

  @override
  void initState() {
    super.initState();
    _isInternetConnection =
        getIt<ConnectivityService>().hasDeviceInternetConnection();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _isInternetConnection,
      builder: (_, AsyncSnapshot<bool> asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const LoadingInfo();
        }
        if (kIsWeb && asyncSnapshot.data == false) {
          return Scaffold(
            body: EmptyContentInfo(
              icon: Icons.wifi_off,
              title: Str.of(context).youAreOffline,
            ),
          );
        }
        return const AutoRouter();
      },
    );
  }
}
