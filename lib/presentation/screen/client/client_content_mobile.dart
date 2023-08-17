import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/client/client_bloc.dart';
import '../../component/body/medium_body_component.dart';
import '../../component/text/title_text_components.dart';
import '../../config/navigation/router.dart';

class ClientContentMobile extends StatefulWidget {
  const ClientContentMobile({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ClientContentMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediumBody(
        child: AutoTabsRouter(
          routes: const [
            ClientActivitiesRoute(),
            ClientStatsRoute(),
          ],
          builder: (context, child) {
            final tabsRouter = AutoTabsRouter.of(context);

            return DefaultTabController(
              length: 4,
              child: NestedScrollView(
                headerSliverBuilder: (BuildContext context, _) {
                  return [
                    SliverAppBar(
                      scrolledUnderElevation: 0.0,
                      expandedHeight: 125,
                      floating: false,
                      pinned: true,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).canvasColor,
                      actions: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.info),
                        ),
                      ],
                      flexibleSpace: const _FlexibleAppBar(),
                    ),
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        TabBar(
                          onTap: (int tabIndex) {
                            tabsRouter.setActiveIndex(tabIndex);
                          },
                          tabs: const [
                            Tab(icon: Icon(Icons.event_note)),
                            Tab(icon: Icon(Icons.bar_chart)),
                            Tab(icon: Icon(Icons.emoji_events)),
                            Tab(icon: Icon(Icons.water_drop)),
                          ],
                        ),
                      ),
                      pinned: true,
                    ),
                  ];
                },
                body: child,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FlexibleAppBar extends StatelessWidget {
  const _FlexibleAppBar();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final double statusBarHeight = MediaQuery.of(context).viewPadding.top;
        final appBarHeight = constraints.biggest.height - statusBarHeight;
        final double horizontalPadding = 3200 / appBarHeight;

        return FlexibleSpaceBar(
          centerTitle: true,
          expandedTitleScale: 1.4,
          titlePadding: EdgeInsetsDirectional.only(
            start: horizontalPadding,
            end: horizontalPadding,
            top: MediaQuery.of(context).viewPadding.top,
            bottom: 16.0,
          ),
          title: _AppBarTitle(
            maxLines: appBarHeight > kToolbarHeight + 24 ? 2 : 1,
          ),
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}

class _AppBarTitle extends StatelessWidget {
  final int? maxLines;

  const _AppBarTitle({this.maxLines});

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
            maxLines: maxLines,
          );
  }
}
