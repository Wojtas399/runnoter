import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/repository_impl/blood_reading_repository_impl.dart';
import 'package:runnoter/domain/model/blood_parameter.dart';
import 'package:runnoter/domain/model/blood_reading.dart';

import '../../mock/firebase/mock_firebase_blood_reading_service.dart';
import '../../util/blood_reading_creator.dart';
import '../../util/blood_reading_dto_creator.dart';

void main() {
  final firebaseBloodReadingsService = MockFirebaseBloodReadingService();
  late BloodReadingRepositoryImpl repository;
  const String userId = 'u1';

  BloodReadingRepositoryImpl createRepository({
    List<BloodReading>? initialState,
  }) =>
      BloodReadingRepositoryImpl(
        firebaseBloodReadingsService: firebaseBloodReadingsService,
        initialData: initialState,
      );

  tearDown(() {
    reset(firebaseBloodReadingsService);
  });

  test(
    'get all readings, '
    'should emit readings existing in repository and should load and emit new readings from remote db',
    () {
      final List<BloodReading> existingReadings = [
        createBloodReading(id: 'br1', userId: userId),
        createBloodReading(id: 'br2', userId: 'u2'),
        createBloodReading(id: 'br3', userId: userId),
        createBloodReading(id: 'br4', userId: 'u3'),
      ];
      final List<firebase.BloodReadingDto> loadedReadingsDtos = [
        createBloodReadingDto(
          id: 'br5',
          userId: userId,
          date: DateTime(2023, 5, 12),
          parameterDtos: const [
            firebase.BloodReadingParameterDto(
              parameter: firebase.BloodParameter.ferritin,
              readingValue: 54.1,
            ),
            firebase.BloodReadingParameterDto(
              parameter: firebase.BloodParameter.tp,
              readingValue: 6.5,
            ),
          ],
        ),
        createBloodReadingDto(
          id: 'br6',
          userId: userId,
          date: DateTime(2023, 6, 1),
          parameterDtos: const [
            firebase.BloodReadingParameterDto(
              parameter: firebase.BloodParameter.sodium,
              readingValue: 139,
            ),
          ],
        ),
      ];
      final List<BloodReading> loadedReadings = [
        createBloodReading(
          id: 'br5',
          userId: userId,
          date: DateTime(2023, 5, 12),
          parameters: const [
            BloodReadingParameter(
              parameter: BloodParameter.ferritin,
              readingValue: 54.1,
            ),
            BloodReadingParameter(
              parameter: BloodParameter.tp,
              readingValue: 6.5,
            ),
          ],
        ),
        createBloodReading(
          id: 'br6',
          userId: userId,
          date: DateTime(2023, 6, 1),
          parameters: const [
            BloodReadingParameter(
              parameter: BloodParameter.sodium,
              readingValue: 139,
            ),
          ],
        ),
      ];
      firebaseBloodReadingsService.mockLoadAllReadings(
        bloodReadingDtos: loadedReadingsDtos,
      );
      repository = createRepository(initialState: existingReadings);

      final Stream<List<BloodReading>?> readings$ = repository.getAllReadings(
        userId: userId,
      );
      readings$.listen((_) {});

      expect(
        readings$,
        emitsInOrder(
          [
            [
              existingReadings[0],
              existingReadings[2],
            ],
            [
              existingReadings[0],
              existingReadings[2],
              ...loadedReadings,
            ],
          ],
        ),
      );
      verify(
        () => firebaseBloodReadingsService.loadAllReadings(
          userId: userId,
        ),
      ).called(1);
    },
  );

  test(
    'add new reading, '
    'should call method from firebase service to add new reading and should add this reading to repository',
    () {
      const String newReadingId = 'br3';
      final DateTime newReadingDate = DateTime(2023, 5, 20);
      const List<BloodReadingParameter> parameters = [
        BloodReadingParameter(
          parameter: BloodParameter.wbc,
          readingValue: 4.45,
        ),
        BloodReadingParameter(
          parameter: BloodParameter.sodium,
          readingValue: 139,
        ),
      ];
      final List<BloodReading> existingReadings = [
        createBloodReading(id: 'br1', userId: userId),
        createBloodReading(id: 'br2', userId: 'u2'),
      ];
      final firebase.BloodReadingDto addedBloodReadingDto =
          createBloodReadingDto(
        id: newReadingId,
        date: newReadingDate,
        userId: userId,
        parameterDtos: const [
          firebase.BloodReadingParameterDto(
            parameter: firebase.BloodParameter.wbc,
            readingValue: 4.45,
          ),
          firebase.BloodReadingParameterDto(
            parameter: firebase.BloodParameter.sodium,
            readingValue: 139,
          ),
        ],
      );
      final BloodReading addedBloodReading = createBloodReading(
        id: newReadingId,
        userId: userId,
        date: newReadingDate,
        parameters: parameters,
      );
      firebaseBloodReadingsService.mockAddNewReading(
        addedBloodReadingDto: addedBloodReadingDto,
      );
      repository = createRepository(initialState: existingReadings);

      final Stream<List<BloodReading>?> bloodReadings$ = repository.dataStream$;
      bloodReadings$.listen((_) {});
      repository.addNewReading(
        userId: userId,
        date: newReadingDate,
        parameters: parameters,
      );

      expect(
        bloodReadings$,
        emitsInOrder(
          [
            existingReadings,
            [
              ...existingReadings,
              addedBloodReading,
            ]
          ],
        ),
      );
    },
  );
}
