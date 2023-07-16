part of 'blood_test_preview_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _AppBar(),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: GetIt.I.get<BodySizes>().mediumBodyWidth,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DateSection(),
                Expanded(
                  child: _Results(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      centerTitle: true,
      title: Text(
        Str.of(context).bloodTestPreviewTitle,
      ),
      actions: context.isMobileSize
          ? const [
              _BloodTestActions(),
            ]
          : null,
    );
  }
}

class _DateSection extends StatelessWidget {
  const _DateSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const _Date(),
          if (!context.isMobileSize) const _BloodTestActions(),
        ],
      ),
    );
  }
}

class _Date extends StatelessWidget {
  const _Date();

  @override
  Widget build(BuildContext context) {
    final DateTime? date = context.select(
      (BloodTestPreviewBloc bloc) => bloc.state.date,
    );

    return TitleLarge(
      date?.toFullDate(context) ?? '--',
    );
  }
}

class _Results extends StatelessWidget {
  const _Results();

  @override
  Widget build(BuildContext context) {
    final List<BloodParameterResult>? parameterResults = context.select(
      (BloodTestPreviewBloc bloc) => bloc.state.parameterResults,
    );

    return BloodParameterResultsList(
      parameterResults: parameterResults,
    );
  }
}
