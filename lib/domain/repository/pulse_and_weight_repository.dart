import '../model/pulse_and_weight.dart';

abstract class PulseAndWeightRepository {
  Future<void> addSurvey({
    required PulseAndWeight pulseAndWeightSurvey,
  });
}
