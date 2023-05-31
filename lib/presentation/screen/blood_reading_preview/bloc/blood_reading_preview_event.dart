part of 'blood_reading_preview_bloc.dart';

abstract class BloodReadingPreviewEvent {
  const BloodReadingPreviewEvent();
}

class BloodReadingPreviewEventInitialize extends BloodReadingPreviewEvent {
  final String bloodReadingId;

  const BloodReadingPreviewEventInitialize({
    required this.bloodReadingId,
  });
}

class BloodReadingPreviewEventBloodReadingUpdated
    extends BloodReadingPreviewEvent {
  final BloodReading? bloodReading;

  const BloodReadingPreviewEventBloodReadingUpdated({
    required this.bloodReading,
  });
}

class BloodReadingPreviewEventDeleteReading extends BloodReadingPreviewEvent {
  const BloodReadingPreviewEventDeleteReading();
}
