import '../firebase.dart';

DistanceUnit mapDistanceUnitFromStringToEnum(String distanceUnit) {
  return DistanceUnit.values.byName(distanceUnit);
}
