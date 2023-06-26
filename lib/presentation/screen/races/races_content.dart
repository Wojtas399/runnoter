part of 'races_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final List<Race>? races = context.select(
      (RacesCubit cubit) => cubit.state,
    );

    return switch (races) {
      null => const LoadingInfo(),
      [] => const _NoRacesInfo(),
      [...] => _RacesList(races: races),
    };
  }
}

class _NoRacesInfo extends StatelessWidget {
  const _NoRacesInfo();

  @override
  Widget build(BuildContext context) {
    return Paddings24(
      child: EmptyContentInfo(
        icon: Icons.emoji_events_outlined,
        title: Str.of(context).racesNoRacesTitle,
        subtitle: Str.of(context).racesNoRacesMessage,
      ),
    );
  }
}
