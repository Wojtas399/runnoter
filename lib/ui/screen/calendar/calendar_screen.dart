import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../data/interface/service/auth_service.dart';
import '../../../../dependency_injection.dart';
import '../../common_feature/calendar/calendar.dart';
import '../../component/page_not_found_component.dart';

@RoutePage()
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getIt<AuthService>().loggedUserId$,
      builder: (_, AsyncSnapshot<String?> snapshot) {
        final String? loggedUserId = snapshot.data;

        return switch (loggedUserId) {
          null => const PageNotFound(),
          String() => Calendar(userId: loggedUserId),
        };
      },
    );
  }
}
