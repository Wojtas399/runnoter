part of 'blood_test_creator_bloc.dart';

abstract class BloodTestCreatorEvent {
  const BloodTestCreatorEvent();
}

class BloodTestCreatorEventInitialize extends BloodTestCreatorEvent {
  const BloodTestCreatorEventInitialize();
}
