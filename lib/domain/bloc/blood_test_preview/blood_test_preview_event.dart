part of 'blood_test_preview_bloc.dart';

abstract class BloodTestPreviewEvent {
  const BloodTestPreviewEvent();
}

class BloodTestPreviewEventInitialize extends BloodTestPreviewEvent {
  const BloodTestPreviewEventInitialize();
}

class BloodTestPreviewEventDeleteTest extends BloodTestPreviewEvent {
  const BloodTestPreviewEventDeleteTest();
}
