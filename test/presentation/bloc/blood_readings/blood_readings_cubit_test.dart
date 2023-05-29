import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/presentation/screen/blood_readings/blood_readings_cubit.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_blood_reading_repository.dart';
import '../../../util/blood_reading_creator.dart';

void main() {
  final authService = MockAuthService();
  final bloodReadingRepository = MockBloodReadingRepository();

  BloodReadingsCubit createCubit() => BloodReadingsCubit(
        authService: authService,
        bloodReadingRepository: bloodReadingRepository,
      );

  tearDown(() {
    reset(authService);
    reset(bloodReadingRepository);
  });

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should finish method call',
    build: () => createCubit(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (BloodReadingsCubit cubit) => cubit.initialize(),
    expect: () => [],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'initialize, '
    'should set listener of blood readings belonging to logged user grouped by year',
    build: () => createCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      bloodReadingRepository.mockGetAllReadings(
        readings: [
          createBloodReading(
            id: 'br1',
            userId: 'u1',
            date: DateTime(2023, 5, 20),
          ),
          createBloodReading(
            id: 'br2',
            userId: 'u1',
            date: DateTime(2023, 2, 10),
          ),
          createBloodReading(
            id: 'br3',
            userId: 'u1',
            date: DateTime(2022, 4, 10),
          ),
          createBloodReading(
            id: 'br4',
            userId: 'u1',
            date: DateTime(2021, 7, 10),
          ),
        ],
      );
    },
    act: (BloodReadingsCubit cubit) => cubit.initialize(),
    expect: () => [
      [
        BloodReadingsFromYear(
          year: 2023,
          bloodReadings: [
            createBloodReading(
              id: 'br1',
              userId: 'u1',
              date: DateTime(2023, 5, 20),
            ),
            createBloodReading(
              id: 'br2',
              userId: 'u1',
              date: DateTime(2023, 2, 10),
            ),
          ],
        ),
        BloodReadingsFromYear(
          year: 2022,
          bloodReadings: [
            createBloodReading(
              id: 'br3',
              userId: 'u1',
              date: DateTime(2022, 4, 10),
            ),
          ],
        ),
        BloodReadingsFromYear(
          year: 2021,
          bloodReadings: [
            createBloodReading(
              id: 'br4',
              userId: 'u1',
              date: DateTime(2021, 7, 10),
            ),
          ],
        ),
      ],
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => bloodReadingRepository.getAllReadings(
          userId: 'u1',
        ),
      ).called(1);
    },
  );
}
