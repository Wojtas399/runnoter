import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/page_not_found_component.dart';
import 'cubit/race_preview_cubit.dart';
import 'race_preview_content.dart';

@RoutePage()
class RacePreviewScreen extends StatelessWidget {
  final String? userId;
  final String? raceId;

  const RacePreviewScreen({
    super.key,
    @PathParam('userId') this.userId,
    @PathParam('raceId') this.raceId,
  });

  @override
  Widget build(BuildContext context) {
    return userId == null || raceId == null
        ? const PageNotFound()
        : BlocProvider(
            create: (_) => RacePreviewCubit(userId: userId!, raceId: raceId!)
              ..initialize(),
            child: const RacePreviewContent(),
          );
  }
}
