import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/run_status.dart';
import '../../domain/entity/settings.dart';
import '../service/distance_unit_service.dart';
import '../service/pace_unit_service.dart';

extension ContextExtensions on BuildContext {
  DistanceUnit get distanceUnit => read<DistanceUnitService>().state;

  PaceUnit get paceUnit => read<PaceUnitService>().state;

  double convertDistanceToDefaultUnit(double distance) =>
      read<DistanceUnitService>().convertToDefault(distance);

  double convertDistanceFromDefaultUnit(double distance) =>
      read<DistanceUnitService>().convertFromDefault(distance);

  ConvertedPace convertPaceFromDefaultUnit(Pace pace) =>
      read<PaceUnitService>().convertFromDefault(pace);

  Pace convertPaceToDefaultUnit(ConvertedPace convertedPace) =>
      read<PaceUnitService>().convertToDefault(convertedPace);
}
