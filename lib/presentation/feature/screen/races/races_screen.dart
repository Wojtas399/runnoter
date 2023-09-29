import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../dependency_injection.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../component/page_not_found_component.dart';
import '../../../feature/common/races/races.dart';

@RoutePage()
class RacesScreen extends StatelessWidget {
  const RacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getIt<AuthService>().loggedUserId$,
      builder: (_, AsyncSnapshot<String?> snapshot) {
        final String? loggedUserId = snapshot.data;

        return switch (loggedUserId) {
          null => const PageNotFound(),
          String() => Races(userId: loggedUserId),
        };
      },
    );
  }
}
