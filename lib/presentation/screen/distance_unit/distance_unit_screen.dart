import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/model/settings.dart';
import '../../../domain/repository/user_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../formatter/settings_formatter.dart';
import '../../service/navigator_service.dart';
import 'distance_unit_cubit.dart';

class DistanceUnitScreen extends StatelessWidget {
  const DistanceUnitScreen({
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
      create: (BuildContext context) => DistanceUnitCubit(
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
          AppLocalizations.of(context)!.distance_unit_label,
        ),
        leading: IconButton(
          onPressed: () {
            navigateBack(context: context);
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
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
        AppLocalizations.of(context)!.distance_unit_selection_text,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class _OptionsToSelect extends StatelessWidget {
  const _OptionsToSelect();

  @override
  Widget build(BuildContext context) {
    final DistanceUnit? selectedDistanceUnit = context.select(
      (DistanceUnitCubit cubit) => cubit.state,
    );
    print(selectedDistanceUnit);

    return Column(
      children: DistanceUnit.values
          .map(
            (DistanceUnit distanceUnit) => RadioListTile<DistanceUnit>(
              title: Text(
                distanceUnit.toUIFormat(context),
              ),
              value: distanceUnit,
              groupValue: selectedDistanceUnit,
              onChanged: (DistanceUnit? distanceUnit) {
                _onDistanceUnitChanged(context, distanceUnit);
              },
            ),
          )
          .toList(),
    );
  }

  void _onDistanceUnitChanged(
    BuildContext context,
    DistanceUnit? distanceUnit,
  ) {
    if (distanceUnit != null) {
      context.read<DistanceUnitCubit>().updateDistanceUnit(
            distanceUnit: distanceUnit,
          );
    }
  }
}
