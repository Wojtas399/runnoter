import 'package:firebase/service/firebase_race_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/date_service.dart';
import '../../data/repository_impl/race_repository_impl.dart';
import '../../domain/repository/race_repository.dart';

class RepositoriesProvider extends StatelessWidget {
  final Widget child;

  const RepositoriesProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<RaceRepository>(
          create: (_) => RaceRepositoryImpl(
            firebaseRaceService: FirebaseRaceService(),
            dateService: DateService(),
          ),
        ),
      ],
      child: child,
    );
  }
}
