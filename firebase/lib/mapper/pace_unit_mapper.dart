import '../firebase.dart';

PaceUnit mapPaceUnitFromStringToEnum(String paceUnit) {
  return PaceUnit.values.byName(paceUnit);
}
