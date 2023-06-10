part of 'blood_test_creator_bloc.dart';

abstract class BloodTestCreatorEvent {
  const BloodTestCreatorEvent();
}

class BloodTestCreatorEventInitialize extends BloodTestCreatorEvent {
  final String? bloodTestId;

  const BloodTestCreatorEventInitialize({
    this.bloodTestId,
  });
}

class BloodTestCreatorEventDateChanged extends BloodTestCreatorEvent {
  final DateTime date;

  const BloodTestCreatorEventDateChanged({
    required this.date,
  });
}

class BloodTestCreatorEventParameterResultChanged
    extends BloodTestCreatorEvent {
  final BloodParameter parameter;
  final double? value;

  const BloodTestCreatorEventParameterResultChanged({
    required this.parameter,
    required this.value,
  });
}

class BloodTestCreatorEventSubmit extends BloodTestCreatorEvent {
  const BloodTestCreatorEventSubmit();
}
