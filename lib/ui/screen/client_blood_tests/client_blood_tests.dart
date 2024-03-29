import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_feature/blood_tests/blood_tests.dart';
import '../../cubit/client/client_cubit.dart';

@RoutePage()
class ClientBloodTestsScreen extends StatelessWidget {
  const ClientBloodTestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BloodTests(userId: context.read<ClientCubit>().clientId);
  }
}
