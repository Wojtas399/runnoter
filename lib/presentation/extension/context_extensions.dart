import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../domain/additional_model/run_status.dart';
import '../../domain/additional_model/settings.dart';
import '../config/screen_sizes.dart';
import '../service/distance_unit_service.dart';
import '../service/pace_unit_service.dart';

extension ContextExtensions on BuildContext {
  Size get _screenSize => MediaQuery.of(this).size;

  bool get isMobileSize =>
      _screenSize.width <= GetIt.I.get<ScreenSizes>().maxMobileWidth;

  bool get isTabletSize =>
      _screenSize.width > GetIt.I.get<ScreenSizes>().maxMobileWidth &&
      _screenSize.width <= GetIt.I.get<ScreenSizes>().maxTabletWidth;

  bool get isDesktopSize =>
      _screenSize.width > GetIt.I.get<ScreenSizes>().maxTabletWidth;

  DistanceUnit get distanceUnit => select(
        (DistanceUnitService service) => service.state,
      );

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
