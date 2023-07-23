import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/blood_tests/blood_tests_cubit.dart';
import 'blood_tests_content.dart';

@RoutePage()
class BloodTestsScreen extends StatelessWidget {
  const BloodTestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BloodTestsCubit()..initialize(),
      child: const BloodTestsContent(),
    );
  }
}
