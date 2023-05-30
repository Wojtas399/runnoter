abstract class BloodReadingPreviewEvent {
  const BloodReadingPreviewEvent();
}

class BloodReadingPreviewEventInitialize extends BloodReadingPreviewEvent {
  final String bloodReadingId;

  const BloodReadingPreviewEventInitialize({
    required this.bloodReadingId,
  });
}

class BloodReadingPreviewEventDeleteReading extends BloodReadingPreviewEvent {
  const BloodReadingPreviewEventDeleteReading();
}
