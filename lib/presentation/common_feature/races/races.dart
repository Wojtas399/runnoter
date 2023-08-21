import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/cubit/races_cubit.dart';
import 'races_content.dart';

class Races extends StatelessWidget {
  final String userId;

  const Races({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RacesCubit(userId: userId)..initialize(),
      child: const RacesContent(),
    );
  }
}
