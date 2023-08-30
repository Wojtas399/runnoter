import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/additional_model/activity_status.dart';
import '../../domain/additional_model/settings.dart';
import '../extension/double_extensions.dart';

class PaceUnitService extends Cubit<PaceUnit> {
  PaceUnitService({
    PaceUnit paceUnit = PaceUnit.minutesPerKilometer,
  }) : super(paceUnit);

  void changeUnit(PaceUnit unit) {
    emit(unit);
  }

  ConvertedPace convertFromDefault(Pace pace) => switch (state) {
        PaceUnit.minutesPerKilometer => ConvertedPaceMinutesPerKilometer(
            minutes: pace.minutes,
            seconds: pace.seconds,
          ),
        PaceUnit.minutesPerMile => _convertToMinutesPerMile(pace),
        PaceUnit.kilometersPerHour => ConvertedPaceKilometersPerHour(
            distance: (60 / pace.toDouble()).decimal(2),
          ),
        PaceUnit.milesPerHour => ConvertedPaceMilesPerHour(
            distance: (37.2822715 / pace.toDouble()).decimal(2),
          ),
      };

  Pace convertToDefault(ConvertedPace convertedPace) => switch (convertedPace) {
        ConvertedPaceMinutesPerKilometer() => Pace(
            minutes: convertedPace.minutes,
            seconds: convertedPace.seconds,
          ),
        ConvertedPaceMinutesPerMile() => _convertFromMinutesPerMile(
            convertedPace,
          ),
        ConvertedPaceKilometersPerHour() => _createPaceFromMinutesPerKilometer(
            60 / convertedPace.distance,
          ),
        ConvertedPaceMilesPerHour() => _createPaceFromMinutesPerKilometer(
            37.2822715 / convertedPace.distance,
          ),
      };

  ConvertedPaceMinutesPerMile _convertToMinutesPerMile(Pace pace) {
    final double minutesPerKilometer = pace.toDouble();
    final double minutesPerMile = minutesPerKilometer * 1.609344;
    final double decimalPart = _getDecimalPart(minutesPerMile);
    return ConvertedPaceMinutesPerMile(
      minutes: (minutesPerMile % 60).toInt(),
      seconds: (60 * decimalPart).toInt(),
    );
  }

  Pace _convertFromMinutesPerMile(ConvertedPaceMinutesPerMile convertedPace) {
    final double minutesPerMile =
        convertedPace.minutes + (convertedPace.seconds / 60);
    final double minutesPerKilometer = minutesPerMile * 0.621371192;
    return _createPaceFromMinutesPerKilometer(minutesPerKilometer);
  }

  double _getDecimalPart(double number) {
    final List<String> numberParts = number.toString().split('.');
    if (numberParts.length == 1) {
      return 0;
    }
    return double.parse(
      '0.${number.toString().split('.')[1]}',
    );
  }

  Pace _createPaceFromMinutesPerKilometer(double minutesPerKilometer) {
    final double decimalPart = _getDecimalPart(minutesPerKilometer);
    return Pace(
      minutes: (minutesPerKilometer % 60).toInt(),
      seconds: (60 * decimalPart).toInt(),
    );
  }
}

extension _PaceExtension on Pace {
  double toDouble() => minutes + (seconds / 60);
}

sealed class ConvertedPace extends Equatable {
  const ConvertedPace();
}

sealed class ConvertedPaceTime extends ConvertedPace {
  final int minutes;
  final int seconds;

  const ConvertedPaceTime({
    required this.minutes,
    required this.seconds,
  });

  @override
  List<Object?> get props => [
        minutes,
        seconds,
      ];
}

sealed class ConvertedPaceDistance extends ConvertedPace {
  final double distance;

  const ConvertedPaceDistance({
    required this.distance,
  });

  @override
  List<Object?> get props => [
        distance,
      ];
}

class ConvertedPaceMinutesPerKilometer extends ConvertedPaceTime {
  const ConvertedPaceMinutesPerKilometer({
    required super.minutes,
    required super.seconds,
  });
}

class ConvertedPaceMinutesPerMile extends ConvertedPaceTime {
  const ConvertedPaceMinutesPerMile({
    required super.minutes,
    required super.seconds,
  });
}

class ConvertedPaceKilometersPerHour extends ConvertedPaceDistance {
  const ConvertedPaceKilometersPerHour({
    required super.distance,
  });
}

class ConvertedPaceMilesPerHour extends ConvertedPaceDistance {
  const ConvertedPaceMilesPerHour({
    required super.distance,
  });
}
