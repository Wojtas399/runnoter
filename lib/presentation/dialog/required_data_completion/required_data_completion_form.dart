import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/required_data_completion/required_data_completion_bloc.dart';
import '../../../domain/entity/user.dart';
import '../../../domain/use_case/add_user_data_use_case.dart';
import '../../component/text_field_component.dart';
import '../../component/two_options_component.dart';

class RequiredDataCompletionForm extends StatelessWidget {
  const RequiredDataCompletionForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _AccountType(),
        SizedBox(height: 16),
        _Gender(),
        SizedBox(height: 24),
        _Name(),
        SizedBox(height: 24),
        _Surname(),
      ],
    );
  }
}

class _AccountType extends StatelessWidget {
  const _AccountType();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    final AccountType? selectedAccountType = context.select(
      (RequiredDataCompletionBloc bloc) => bloc.state.accountType,
    );

    return selectedAccountType == null
        ? const SizedBox()
        : TwoOptions<AccountType>(
            label: str.accountType,
            selectedValue: selectedAccountType,
            option1: OptionParams(label: str.runner, value: AccountType.runner),
            option2: OptionParams(label: str.coach, value: AccountType.coach),
            onChanged: (accountType) => _onChanged(context, accountType),
          );
  }

  void _onChanged(BuildContext context, AccountType accountType) {
    context.read<RequiredDataCompletionBloc>().add(
          RequiredDataCompletionEventAccountTypeChanged(
            accountType: accountType,
          ),
        );
  }
}

class _Gender extends StatelessWidget {
  const _Gender();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);
    final Gender? selectedGender = context.select(
      (RequiredDataCompletionBloc bloc) => bloc.state.gender,
    );

    return selectedGender == null
        ? const SizedBox()
        : TwoOptions<Gender>(
            label: str.gender,
            selectedValue: selectedGender,
            option1: OptionParams(label: str.male, value: Gender.male),
            option2: OptionParams(label: str.female, value: Gender.female),
            onChanged: (gender) => _onChanged(context, gender),
          );
  }

  void _onChanged(BuildContext context, Gender gender) {
    context.read<RequiredDataCompletionBloc>().add(
          RequiredDataCompletionEventGenderChanged(gender: gender),
        );
  }
}

class _Name extends StatelessWidget {
  const _Name();

  @override
  Widget build(BuildContext context) {
    final bool isValid = context.select(
      (RequiredDataCompletionBloc bloc) => bloc.state.isNameValid,
    );
    final str = Str.of(context);

    return TextFieldComponent(
      icon: Icons.person,
      label: str.name,
      isRequired: true,
      onChanged: (String? value) => _onChanged(value, context),
      validator: (_) => !isValid ? str.invalidNameOrSurnameMessage : null,
    );
  }

  void _onChanged(String? value, BuildContext context) {
    context.read<RequiredDataCompletionBloc>().add(
          RequiredDataCompletionEventNameChanged(name: value ?? ''),
        );
  }
}

class _Surname extends StatelessWidget {
  const _Surname();

  @override
  Widget build(BuildContext context) {
    final bool isValid = context.select(
      (RequiredDataCompletionBloc bloc) => bloc.state.isSurnameValid,
    );
    final str = Str.of(context);

    return TextFieldComponent(
      icon: Icons.person,
      label: str.surname,
      isRequired: true,
      onChanged: (String? value) => _onChanged(value, context),
      validator: (_) => !isValid ? str.invalidNameOrSurnameMessage : null,
    );
  }

  void _onChanged(String? value, BuildContext context) {
    context.read<RequiredDataCompletionBloc>().add(
          RequiredDataCompletionEventSurnameChanged(surname: value ?? ''),
        );
  }
}
