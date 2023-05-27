import 'package:firebase/model/blood_parameter.dart';

abstract class BloodReadingCreatorEvent {
  const BloodReadingCreatorEvent();
}

class BloodReadingCreatorEventDateChanged extends BloodReadingCreatorEvent {
  final DateTime date;

  const BloodReadingCreatorEventDateChanged({
    required this.date,
  });
}

class BloodReadingCreatorEventBloodParameterChanged
    extends BloodReadingCreatorEvent {
  final BloodParameter bloodParameter;
  final double parameterValue;

  const BloodReadingCreatorEventBloodParameterChanged({
    required this.bloodParameter,
    required this.parameterValue,
  });
}

class BloodReadingCreatorEventSubmit extends BloodReadingCreatorEvent {
  const BloodReadingCreatorEventSubmit();
}
