import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/client/client_bloc.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/text/title_text_components.dart';
import 'client_details.dart';

class ClientContentMobile extends StatelessWidget {
  final int activePageIndex;
  final Function(int pageIndex) onPageChanged;
  final Widget child;

  const ClientContentMobile({
    super.key,
    required this.activePageIndex,
    required this.onPageChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: activePageIndex,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).canvasColor,
          centerTitle: true,
          title: const _AppBarTitle(),
          actions: const [ClientDetailsIcon(), GapHorizontal8()],
          bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.inversePrimary,
            unselectedLabelColor:
                Theme.of(context).colorScheme.outlineVariant.withOpacity(0.75),
            indicatorColor: Theme.of(context).colorScheme.inversePrimary,
            onTap: onPageChanged,
            tabs: const [
              Tab(icon: Icon(Icons.event_note)),
              Tab(icon: Icon(Icons.bar_chart)),
              Tab(icon: Icon(Icons.emoji_events)),
              Tab(icon: Icon(Icons.water_drop)),
            ],
          ),
        ),
        body: SafeArea(child: child),
      ),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    final String? fullName = context.select(
      (ClientBloc bloc) => bloc.state.name == null || bloc.state.surname == null
          ? null
          : '${bloc.state.name} ${bloc.state.surname}',
    );

    return fullName == null
        ? CircularProgressIndicator(color: Theme.of(context).canvasColor)
        : TitleLarge(
            fullName,
            textAlign: TextAlign.center,
            color: Theme.of(context).canvasColor,
            overflow: TextOverflow.ellipsis,
          );
  }
}
