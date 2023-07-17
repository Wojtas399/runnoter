import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/blood_tests/blood_tests_cubit.dart';
import '../../../domain/repository/blood_test_repository.dart';
import '../../../domain/service/auth_service.dart';
import 'blood_tests_content.dart';

@RoutePage()
class BloodTestsScreen extends StatelessWidget {
  const BloodTestsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _CubitProvider(
      child: BloodTestsContent(),
    );
  }
}

class _CubitProvider extends StatelessWidget {
  final Widget child;

  const _CubitProvider({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BloodTestsCubit(
        authService: context.read<AuthService>(),
        bloodTestRepository: context.read<BloodTestRepository>(),
      )..initialize(),
      child: child,
    );
  }
}
