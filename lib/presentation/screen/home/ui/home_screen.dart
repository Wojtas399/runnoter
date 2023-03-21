import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/bloc_with_status_listener_component.dart';
import '../../../config/navigation/routes.dart';
import '../../../service/navigator_service.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import 'home_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _BlocProvider(
      child: _BlocListener(
        child: HomeContent(),
      ),
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
      create: (_) => HomeBloc(),
      child: child,
    );
  }
}

class _BlocListener extends StatelessWidget {
  final Widget child;

  const _BlocListener({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocWithStatusListener<HomeBloc, HomeState, HomeInfo, dynamic>(
      child: child,
      onInfo: (HomeInfo info) {
        _manageInfo(context, info);
      },
    );
  }

  void _manageInfo(BuildContext context, HomeInfo info) {
    switch (info) {
      case HomeInfo.userSignedOut:
        navigateAndRemoveUntil(
          context: context,
          route: Routes.signIn,
        );
        break;
    }
  }
}
