import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/required_data_completion/required_data_completion_bloc.dart';
import '../../../domain/entity/user.dart';
import '../../component/text_field_component.dart';

class RequiredDataCompletionForm extends StatelessWidget {
  const RequiredDataCompletionForm({super.key});

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 24);

    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Gender(),
        gap,
        _Name(),
        gap,
        _Surname(),
      ],
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

    return Row(
      children: [
        Expanded(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
            title: Text(str.male),
            leading: Radio(
              value: Gender.male,
              groupValue: selectedGender,
              onChanged: (Gender? gender) => _onGenderChanged(context, gender),
            ),
            onTap: () => _onGenderChanged(context, Gender.male),
          ),
        ),
        Expanded(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
            title: Text(str.female),
            leading: Radio(
              value: Gender.female,
              groupValue: selectedGender,
              onChanged: (Gender? gender) => _onGenderChanged(context, gender),
            ),
            onTap: () => _onGenderChanged(context, Gender.female),
          ),
        ),
      ],
    );
  }

  void _onGenderChanged(BuildContext context, Gender? gender) {
    if (gender != null) {
      context.read<RequiredDataCompletionBloc>().add(
            RequiredDataCompletionEventGenderChanged(gender: gender),
          );
    }
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
