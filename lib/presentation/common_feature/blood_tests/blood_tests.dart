import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/cubit/blood_tests_cubit.dart';
import 'blood_tests_content.dart';

class BloodTests extends StatelessWidget {
  final String userId;

  const BloodTests({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BloodTestsCubit(userId: userId)..initialize(),
      child: const BloodTestsContent(),
    );
  }
}
