import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/mileage/mileage_cubit.dart';
import 'mileage_content.dart';

@RoutePage()
class MileageScreen extends StatelessWidget {
  const MileageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MileageCubit()..initialize(),
      child: const MileageContent(),
    );
  }
}
