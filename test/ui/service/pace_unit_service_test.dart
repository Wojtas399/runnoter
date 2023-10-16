import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/entity/user.dart';
import 'package:runnoter/data/model/activity.dart';
import 'package:runnoter/ui/service/pace_unit_service.dart';

void main() {
  test(
    'convert from default, '
    'minutes per kilometer, '
    'should just assign minutes and seconds to ConvertedPace model',
    () {
      const Pace pace = Pace(minutes: 5, seconds: 45);
      const ConvertedPace expectedConvertedPace =
          ConvertedPaceMinutesPerKilometer(
        minutes: 5,
        seconds: 45,
      );
      final service = PaceUnitService();

      final ConvertedPace convertedPace = service.convertFromDefault(pace);

      expect(convertedPace, expectedConvertedPace);
    },
  );

  test(
    'convert from default, '
    'minutes per mile, '
    'should convert min/km to min/mil',
    () {
      const Pace pace = Pace(minutes: 5, seconds: 45);
      const ConvertedPace expectedConvertedPace = ConvertedPaceMinutesPerMile(
        minutes: 9,
        seconds: 15,
      );
      final service = PaceUnitService(paceUnit: PaceUnit.minutesPerMile);

      final ConvertedPace convertedPace = service.convertFromDefault(pace);

      expect(convertedPace, expectedConvertedPace);
    },
  );

  test(
    'convert from default, '
    'kilometers per hour, '
    'should convert min/km to km/h',
    () {
      const Pace pace = Pace(minutes: 5, seconds: 45);
      const ConvertedPace expectedConvertedPace =
          ConvertedPaceKilometersPerHour(distance: 10.43);
      final service = PaceUnitService(paceUnit: PaceUnit.kilometersPerHour);

      final ConvertedPace convertedPace = service.convertFromDefault(pace);

      expect(convertedPace, expectedConvertedPace);
    },
  );

  test(
    'convert from default, '
    'miles per hour, '
    'should convert min/km to mil/h',
    () {
      const Pace pace = Pace(minutes: 5, seconds: 45);
      const ConvertedPace expectedConvertedPace = ConvertedPaceMilesPerHour(
        distance: 6.48,
      );
      final service = PaceUnitService(paceUnit: PaceUnit.milesPerHour);

      final ConvertedPace convertedPace = service.convertFromDefault(pace);

      expect(convertedPace, expectedConvertedPace);
    },
  );

  test(
    'convert to default, '
    'minutes per kilometer, '
    'should just assign minutes and seconds to Pace model',
    () {
      const ConvertedPace convertedPace = ConvertedPaceMinutesPerKilometer(
        minutes: 5,
        seconds: 45,
      );
      const Pace expectedPace = Pace(minutes: 5, seconds: 45);
      final service = PaceUnitService();

      final Pace pace = service.convertToDefault(convertedPace);

      expect(pace, expectedPace);
    },
  );

  test(
    'convert to default, '
    'minutes per mile, '
    'should convert min/mil to min/km',
    () {
      const ConvertedPace convertedPace = ConvertedPaceMinutesPerMile(
        minutes: 9,
        seconds: 15,
      );
      const Pace expectedPace = Pace(minutes: 5, seconds: 44);
      final service = PaceUnitService();

      final Pace pace = service.convertToDefault(convertedPace);

      expect(pace, expectedPace);
    },
  );

  test(
    'convert to default, '
    'kilometers per hour, '
    'should convert km/h to min/km',
    () {
      const ConvertedPace convertedPace = ConvertedPaceKilometersPerHour(
        distance: 15.4,
      );
      const Pace expectedPace = Pace(minutes: 3, seconds: 53);
      final service = PaceUnitService();

      final Pace pace = service.convertToDefault(convertedPace);

      expect(pace, expectedPace);
    },
  );

  test(
    'convert to default, '
    'miles per hour, '
    'should convert mil/h to min/km',
    () {
      const ConvertedPace convertedPace = ConvertedPaceMilesPerHour(
        distance: 15.4,
      );
      const Pace expectedPace = Pace(minutes: 2, seconds: 25);
      final service = PaceUnitService();

      final Pace pace = service.convertToDefault(convertedPace);

      expect(pace, expectedPace);
    },
  );
}
