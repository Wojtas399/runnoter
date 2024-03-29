import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../dependency_injection.dart';
import '../../../data/service/auth/auth_service.dart';
import '../../common_feature/blood_tests/blood_tests.dart';
import '../../component/page_not_found_component.dart';

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
