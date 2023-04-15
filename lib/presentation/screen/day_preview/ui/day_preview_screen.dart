import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/day_preview_bloc.dart';
import '../bloc/day_preview_event.dart';
import 'day_preview_content.dart';

class DayPreviewScreen extends StatelessWidget {
  final DateTime date;

  const DayPreviewScreen({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return _BlocProvider(
      date: date,
      child: const DayPreviewContent(),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final DateTime date;
  final Widget child;

  const _BlocProvider({
    required this.date,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DayPreviewBloc()
        ..add(
          DayPreviewEventInitialize(
            date: date,
          ),
        ),
      child: child,
    );
  }
}
