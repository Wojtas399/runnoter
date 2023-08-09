import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/cubit/races_cubit.dart';
import 'races_content.dart';

@RoutePage()
class RacesScreen extends StatelessWidget {
  const RacesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RacesCubit()..initialize(),
      child: const SafeArea(
        child: RacesContent(),
      ),
    );
  }
}
