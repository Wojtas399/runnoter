part of 'blood_tests_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final List<BloodTestsFromYear>? bloodTestsSortedByYear = context.select(
      (BloodTestsCubit cubit) => cubit.state,
    );

    return SafeArea(
      child: switch (bloodTestsSortedByYear) {
        null => const _LoadingContent(),
        [] => const _NoTestsInfo(),
        [...] => _BloodTestsList(
            bloodTestsSortedByYear: bloodTestsSortedByYear,
          )
      },
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _NoTestsInfo extends StatelessWidget {
  const _NoTestsInfo();

  @override
  Widget build(BuildContext context) {
    return Paddings24(
      child: EmptyContentInfo(
        icon: Icons.water_drop_outlined,
        title: Str.of(context).bloodTestsNoTestsTitle,
        subtitle: Str.of(context).bloodTestsNoTestsMessage,
      ),
    );
  }
}
