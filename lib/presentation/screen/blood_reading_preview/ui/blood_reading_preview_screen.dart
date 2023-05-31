import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/repository/blood_reading_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../bloc/blood_reading_preview_bloc.dart';

class BloodReadingPreviewScreen extends StatelessWidget {
  final String bloodReadingId;

  const BloodReadingPreviewScreen({
    super.key,
    required this.bloodReadingId,
  });

  @override
  Widget build(BuildContext context) {
    return _BlocProvider(
      bloodReadingId: bloodReadingId,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Blood reading preview'),
        ),
      ),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final String bloodReadingId;
  final Widget child;

  const _BlocProvider({
    required this.bloodReadingId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => BloodReadingPreviewBloc(
        authService: context.read<AuthService>(),
        bloodReadingRepository: context.read<BloodReadingRepository>(),
      )..add(
          BloodReadingPreviewEventInitialize(
            bloodReadingId: bloodReadingId,
          ),
        ),
      child: child,
    );
  }
}
