import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/settings.dart';
import '../../domain/service/distance_unit_service.dart';

extension ContextExtensions on BuildContext {
  DistanceUnit get distanceUnit => read<DistanceUnitService>().state;

  double convertDistanceToDefaultUnit(double distance) =>
      read<DistanceUnitService>().convertToDefault(distance);

  double convertDistanceFromDefaultUnit(double distance) =>
      read<DistanceUnitService>().convertFromDefault(distance);
}
