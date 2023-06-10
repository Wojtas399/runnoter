import 'package:flutter_bloc/flutter_bloc.dart';

import '../entity/settings.dart';

class DistanceUnitService extends Cubit<DistanceUnit> {
  DistanceUnitService({
    DistanceUnit distanceUnit = DistanceUnit.kilometers,
  }) : super(distanceUnit);

  void changeUnit(DistanceUnit unit) {
    emit(unit);
  }

  double convertFromDefault(double distance) => switch (state) {
        DistanceUnit.kilometers => distance,
        DistanceUnit.miles => distance * 0.621371192,
      };

  double convertToDefault(double distance) => switch (state) {
        DistanceUnit.kilometers => distance,
        DistanceUnit.miles => distance * 1.609344,
      };
}
