part of 'blood_reading_creator_bloc.dart';

abstract class BloodReadingCreatorEvent {
  const BloodReadingCreatorEvent();
}

class BloodReadingCreatorEventDateChanged extends BloodReadingCreatorEvent {
  final DateTime date;

  const BloodReadingCreatorEventDateChanged({
    required this.date,
  });
}

class BloodReadingCreatorEventBloodReadingParameterChanged
    extends BloodReadingCreatorEvent {
  final BloodParameter bloodParameter;
  final double parameterValue;

  const BloodReadingCreatorEventBloodReadingParameterChanged({
    required this.bloodParameter,
    required this.parameterValue,
  });
}

class BloodReadingCreatorEventSubmit extends BloodReadingCreatorEvent {
  const BloodReadingCreatorEventSubmit();
}
