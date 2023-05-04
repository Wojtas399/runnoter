import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';

class HomeAppBar extends StatelessWidget with PreferredSizeWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    final List<String> pageTitles = [
      str.homeCurrentWeekPageTitle,
      str.homeCalendarPageTitle,
      str.homePulseAndWeightPageTitle,
    ];
    final HomePage currentPage = context.select(
      (HomeBloc bloc) => bloc.state.currentPage,
    );

    return AppBar(
      title: Text(
        pageTitles[currentPage.index],
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
