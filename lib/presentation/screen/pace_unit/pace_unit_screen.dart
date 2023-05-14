import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/model/settings.dart';
import '../../../domain/repository/user_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../formatter/settings_formatter.dart';
import '../../service/navigator_service.dart';
import 'pace_unit_cubit.dart';

class PaceUnitScreen extends StatelessWidget {
  const PaceUnitScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _CubitProvider(
      child: _Content(),
    );
  }
}

class _CubitProvider extends StatelessWidget {
  final Widget child;

  const _CubitProvider({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => PaceUnitCubit(
        authService: context.read<AuthService>(),
        userRepository: context.read<UserRepository>(),
      )..initialize(),
      child: child,
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Str.of(context).paceUnit,
        ),
        leading: IconButton(
          onPressed: () {
            navigateBack(context: context);
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: const SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(),
            SizedBox(height: 16),
            _OptionsToSelect(),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Text(
        Str.of(context).paceUnitSelect,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class _OptionsToSelect extends StatelessWidget {
  const _OptionsToSelect();

  @override
  Widget build(BuildContext context) {
    final PaceUnit? selectedDistanceUnit = context.select(
      (PaceUnitCubit cubit) => cubit.state,
    );

    return Column(
      children: PaceUnit.values
          .map(
            (PaceUnit paceUnit) => RadioListTile<PaceUnit>(
              title: Text(
                paceUnit.toUIFormat(context),
              ),
              value: paceUnit,
              groupValue: selectedDistanceUnit,
              onChanged: (PaceUnit? paceUnit) {
                _onPaceUnitChanged(context, paceUnit);
              },
            ),
          )
          .toList(),
    );
  }

  void _onPaceUnitChanged(
    BuildContext context,
    PaceUnit? newPaceUnit,
  ) {
    if (newPaceUnit != null) {
      context.read<PaceUnitCubit>().updatePaceUnit(
            newPaceUnit: newPaceUnit,
          );
    }
  }
}
