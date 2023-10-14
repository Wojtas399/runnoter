import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../data/interface/service/auth_service.dart';
import '../../../../dependency_injection.dart';
import '../../../component/page_not_found_component.dart';
import '../../../feature/common/blood_tests/blood_tests.dart';

@RoutePage()
class BloodTestsScreen extends StatelessWidget {
  const BloodTestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getIt<AuthService>().loggedUserId$,
      builder: (context, AsyncSnapshot<String?> snapshot) {
        final String? loggedUserId = snapshot.data;

        return switch (loggedUserId) {
          null => const PageNotFound(),
          String() => BloodTests(userId: loggedUserId),
        };
      },
    );
  }
}
