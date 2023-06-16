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
        null => const LoadingInfo(),
        [] => const _NoTestsInfo(),
        [...] => _BloodTestsList(
            bloodTestsSortedByYear: bloodTestsSortedByYear,
          )
      },
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
