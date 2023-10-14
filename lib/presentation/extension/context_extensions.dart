import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/additional_model/activity_status.dart';
import '../../domain/additional_model/settings.dart';
import '../service/distance_unit_service.dart';
import '../service/language_service.dart';
import '../service/pace_unit_service.dart';

const int _maxMobileWidth = 600;
const int _maxTabletWidth = 1100;

extension ContextExtensions on BuildContext {
  Size get _screenSize => MediaQuery.of(this).size;

  String? get languageCode =>
      select((LanguageService service) => service.state).locale?.languageCode;

  bool get isMobileSize => _screenSize.width <= _maxMobileWidth;

  bool get isTabletSize =>
      _screenSize.width > _maxMobileWidth &&
      _screenSize.width <= _maxTabletWidth;

  bool get isDesktopSize => _screenSize.width > _maxTabletWidth;

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
