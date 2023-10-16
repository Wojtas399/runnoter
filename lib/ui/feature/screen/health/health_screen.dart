import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/interface/service/auth_service.dart';
import '../../../../dependency_injection.dart';
import '../../../../domain/cubit/today_measurement_cubit.dart';
import '../../../component/page_not_found_component.dart';
import '../../../cubit/health_stats/health_stats_cubit.dart';
import 'health_content.dart';

@RoutePage()
class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getIt<AuthService>().loggedUserId$,
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        final String? loggedUserId = snapshot.data;
        return loggedUserId != null
            ? MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) => TodayMeasurementCubit()..initialize(),
                  ),
                  BlocProvider(
                    create: (_) =>
                        HealthStatsCubit(userId: loggedUserId)..initialize(),
                  )
                ],
                child: const HealthContent(),
              )
            : const PageNotFound();
      },
    );
  }
}
