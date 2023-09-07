import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../../domain/cubit/mileage_stats/mileage_stats_cubit.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/page_not_found_component.dart';
import 'mileage_content.dart';

@RoutePage()
class MileageScreen extends StatelessWidget {
  const MileageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getIt<AuthService>().loggedUserId$,
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        final String? loggedUserId = snapshot.data;
        return loggedUserId != null
            ? BlocProvider(
                create: (_) =>
                    MileageStatsCubit(userId: loggedUserId)..initialize(),
                child: const MileageContent(),
              )
            : const PageNotFound();
      },
    );
  }
}
