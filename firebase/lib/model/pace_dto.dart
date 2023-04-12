part of firebase;

class PaceDto extends Equatable {
  final int minutes;
  final int seconds;

  const PaceDto({
    required this.minutes,
    required this.seconds,
  })  : assert(minutes >= 0 && minutes < 60),
        assert(seconds >= 0 && seconds < 60);

  PaceDto.fromJson(Map<String, dynamic> json)
      : this(
          minutes: json[_PaceField.minutes],
          seconds: json[_PaceField.seconds],
        );

  @override
  List<Object> get props => [
        minutes,
        seconds,
      ];

  Map<String, dynamic> toJson() => {
        _PaceField.minutes: minutes,
        _PaceField.seconds: seconds,
      };
}

class _PaceField {
  static const String minutes = 'minutes';
  static const String seconds = 'seconds';
}
