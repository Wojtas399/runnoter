import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/page_not_found_component.dart';
import '../../cubit/blood_test_preview/blood_test_preview_cubit.dart';
import 'blood_test_preview_content.dart';

@RoutePage()
class BloodTestPreviewScreen extends StatelessWidget {
  final String? userId;
  final String? bloodTestId;

  const BloodTestPreviewScreen({
    super.key,
    @PathParam('userId') this.userId,
    @PathParam('bloodTestId') this.bloodTestId,
  });

  @override
  Widget build(BuildContext context) {
    return userId != null && bloodTestId != null
        ? BlocProvider(
            create: (_) => BloodTestPreviewCubit(
              userId: userId!,
              bloodTestId: bloodTestId!,
            )..initialize(),
            child: const BloodTestPreviewContent(),
          )
        : const PageNotFound();
  }
}
