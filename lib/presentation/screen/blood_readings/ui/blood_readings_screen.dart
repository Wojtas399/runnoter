import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/model/blood_reading.dart';
import '../../../../domain/repository/blood_reading_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../component/big_button_component.dart';
import '../../../component/empty_content_info_component.dart';
import '../../../config/navigation/routes.dart';
import '../../../service/navigator_service.dart';
import '../blood_readings_cubit.dart';

class BloodReadingsScreen extends StatelessWidget {
  const BloodReadingsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _CubitProvider(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            _AddNewReadingButton(),
            Expanded(
              child: _BloodReadingsList(),
            ),
          ],
        ),
      ),
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
      create: (_) => BloodReadingsCubit(
        authService: context.read<AuthService>(),
        bloodReadingRepository: context.read<BloodReadingRepository>(),
      )..initialize(),
      child: child,
    );
  }
}

class _AddNewReadingButton extends StatelessWidget {
  const _AddNewReadingButton();

  @override
  Widget build(BuildContext context) {
    return BigButton(
      label: Str.of(context).bloodAddBloodTest,
      onPressed: () {
        _onPressed(context);
      },
    );
  }

  void _onPressed(BuildContext context) {
    navigateTo(
      context: context,
      route: const BloodTestCreatorRoute(),
    );
  }
}

class _BloodReadingsList extends StatelessWidget {
  const _BloodReadingsList();

  @override
  Widget build(BuildContext context) {
    final List<BloodReading>? bloodReadings = context.select(
      (BloodReadingsCubit cubit) => cubit.state,
    );

    if (bloodReadings == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (bloodReadings.isEmpty) {
      return EmptyContentInfo(
        title: 'Brak badań krwi',
      );
    } else {
      return ListView.builder(
        itemCount: bloodReadings.length,
        itemBuilder: (_, int itemIndex) {
          return Text(bloodReadings[itemIndex].id);
        },
      );
    }
  }
}
