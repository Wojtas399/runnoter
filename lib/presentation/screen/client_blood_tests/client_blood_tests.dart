import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/client/client_bloc.dart';
import '../../component/blood_tests/blood_tests_component.dart';

@RoutePage()
class ClientBloodTestsScreen extends StatelessWidget {
  const ClientBloodTestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BloodTests(userId: context.read<ClientBloc>().clientId);
  }
}
