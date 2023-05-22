import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/repository/blood_test_repository.dart';
import '../bloc/blood_test_creator_bloc.dart';

part 'blood_test_creator_content.dart';

class BloodTestCreatorScreen extends StatelessWidget {
  const BloodTestCreatorScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _BlocProvider(
      child: _Content(),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final Widget child;

  const _BlocProvider({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BloodTestCreatorBloc(
        bloodTestRepository: context.read<BloodTestRepository>(),
      )..add(
          const BloodTestCreatorEventInitialize(),
        ),
      child: child,
    );
  }
}
