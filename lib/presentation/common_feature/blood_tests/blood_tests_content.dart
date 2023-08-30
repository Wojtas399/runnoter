import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/cubit/blood_tests_cubit.dart';
import '../../component/body/medium_body_component.dart';
import '../../component/empty_content_info_component.dart';
import '../../component/loading_info_component.dart';
import '../../component/padding/paddings_24.dart';
import 'blood_tests_list.dart';

class BloodTestsContent extends StatelessWidget {
  const BloodTestsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const MediumBody(
      child: Paddings24(
        child: _BloodTests(),
      ),
    );
  }
}

class _BloodTests extends StatelessWidget {
  const _BloodTests();

  @override
  Widget build(BuildContext context) {
    final List<BloodTestsFromYear>? bloodTestsSortedByYear = context.select(
      (BloodTestsCubit cubit) => cubit.state,
    );

    return switch (bloodTestsSortedByYear) {
      null => const LoadingInfo(),
      [] => EmptyContentInfo(
          icon: Icons.water_drop_outlined,
          title: Str.of(context).bloodTestsNoTestsTitle,
          subtitle: Str.of(context).bloodTestsNoTestsMessage,
        ),
      [...] => BloodTestsList(bloodTestsSortedByYear: bloodTestsSortedByYear),
    };
  }
}
