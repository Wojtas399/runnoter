part of 'blood_test_preview_bloc.dart';

abstract class BloodTestPreviewEvent {
  const BloodTestPreviewEvent();
}

class BloodTestPreviewEventInitialize extends BloodTestPreviewEvent {
  final String bloodTestId;

  const BloodTestPreviewEventInitialize({
    required this.bloodTestId,
  });
}

class BloodTestPreviewEventBloodTestUpdated extends BloodTestPreviewEvent {
  final BloodTest? bloodTest;

  const BloodTestPreviewEventBloodTestUpdated({
    required this.bloodTest,
  });
}

class BloodTestPreviewEventDeleteTest extends BloodTestPreviewEvent {
  const BloodTestPreviewEventDeleteTest();
}
