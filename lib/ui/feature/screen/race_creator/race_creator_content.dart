import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../data/entity/race.dart';
import '../../../component/big_button_component.dart';
import '../../../component/body/medium_body_component.dart';
import '../../../component/gap/gap_components.dart';
import '../../../component/loading_info_component.dart';
import '../../../component/padding/paddings_24.dart';
import '../../../cubit/race_creator/race_creator_cubit.dart';
import '../../../model/cubit_status.dart';
import '../../../service/dialog_service.dart';
import 'race_creator_form.dart';

class RaceCreatorContent extends StatelessWidget {
  const RaceCreatorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await askForConfirmationToLeave(
        areUnsavedChanges: context.read<RaceCreatorCubit>().state.canSubmit,
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const _AppBarTitle(),
        ),
        body: const SafeArea(
          child: SingleChildScrollView(
            child: MediumBody(
              child: Paddings24(
                child: _Form(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    final Race? race = context.select(
      (RaceCreatorCubit cubit) => cubit.state.race,
    );
    String title = Str.of(context).raceCreatorNewRaceTitle;
    if (race != null) {
      title = Str.of(context).raceCreatorEditRaceTitle;
    }
    return Text(title);
  }
}

class _Form extends StatelessWidget {
  const _Form();

  @override
  Widget build(BuildContext context) {
    final CubitStatus cubitStatus = context.select(
      (RaceCreatorCubit cubit) => cubit.state.status,
    );

    return cubitStatus is CubitStatusInitial
        ? const LoadingInfo()
        : const Column(
            children: [
              RaceCreatorForm(),
              Gap40(),
              _SubmitButton(),
            ],
          );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bool isEditMode = context.select(
      (RaceCreatorCubit cubit) => cubit.state.race != null,
    );
    final bool isDisabled = context.select(
      (RaceCreatorCubit cubit) => !cubit.state.canSubmit,
    );

    return BigButton(
      label: isEditMode ? Str.of(context).save : Str.of(context).add,
      isDisabled: isDisabled,
      onPressed: context.read<RaceCreatorCubit>().submit,
    );
  }
}
