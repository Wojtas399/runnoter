import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/bloc_status.dart';
import '../../../domain/bloc/race_creator/race_creator_bloc.dart';
import '../../../domain/entity/race.dart';
import '../../component/big_button_component.dart';
import '../../component/body/medium_body_component.dart';
import '../../component/loading_info_component.dart';
import '../../service/dialog_service.dart';
import '../../service/utils.dart';
import 'race_creator_form.dart';

class RaceCreatorContent extends StatelessWidget {
  const RaceCreatorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bool confirmationToLeave = await askForConfirmationToLeave(
          areUnsavedChanges: context.read<RaceCreatorBloc>().state.canSubmit,
        );
        if (confirmationToLeave) unfocusInputs();
        return confirmationToLeave;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const _AppBarTitle(),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: unfocusInputs,
              child: MediumBody(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  color: Colors.transparent,
                  child: const _Form(),
                ),
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
      (RaceCreatorBloc bloc) => bloc.state.race,
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
    final BlocStatus blocStatus = context.select(
      (RaceCreatorBloc bloc) => bloc.state.status,
    );

    return blocStatus is BlocStatusInitial
        ? const LoadingInfo()
        : const Column(
            children: [
              RaceCreatorForm(),
              SizedBox(height: 40),
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
      (RaceCreatorBloc bloc) => bloc.state.race != null,
    );
    final bool isDisabled = context.select(
      (RaceCreatorBloc bloc) => !bloc.state.canSubmit,
    );

    return BigButton(
      label: isEditMode ? Str.of(context).save : Str.of(context).add,
      isDisabled: isDisabled,
      onPressed: () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<RaceCreatorBloc>().add(
          const RaceCreatorEventSubmit(),
        );
  }
}
