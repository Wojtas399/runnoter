import 'package:flutter_bloc/flutter_bloc.dart';

import '../entity/settings.dart';

class DistanceUnitService extends Cubit<DistanceUnit> {
  DistanceUnitService({
    DistanceUnit distanceUnit = DistanceUnit.kilometers,
  }) : super(distanceUnit);

  void changeUnit(DistanceUnit unit) {
    emit(unit);
  }

  double convertDistance(double distanceInKm) => switch (state) {
        DistanceUnit.kilometers => distanceInKm,
        DistanceUnit.miles => double.parse(
            (distanceInKm * 0.621371192).toStringAsFixed(2),
          ),
      };
}
