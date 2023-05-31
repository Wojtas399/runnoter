import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/blood_parameter.dart';
import 'package:runnoter/domain/model/blood_reading.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/blood_test_preview/bloc/blood_reading_preview_bloc.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_blood_reading_repository.dart';
import '../../../util/blood_reading_creator.dart';

void main() {
  final authService = MockAuthService();
  final bloodReadingRepository = MockBloodReadingRepository();

  BloodReadingPreviewBloc createBloc({
    String? bloodReadingId,
  }) =>
      BloodReadingPreviewBloc(
        authService: authService,
        bloodReadingRepository: bloodReadingRepository,
        state: BloodReadingPreviewState(
          status: const BlocStatusInitial(),
          bloodReadingId: bloodReadingId,
        ),
      );

  BloodReadingPreviewState createState({
    BlocStatus status = const BlocStatusInitial(),
    String? bloodReadingId,
    DateTime? date,
    List<BloodReadingParameter>? readParameters,
  }) =>
      BloodReadingPreviewState(
        status: status,
        bloodReadingId: bloodReadingId,
        date: date,
        readParameters: readParameters,
      );

  tearDown(() {
    reset(authService);
    reset(bloodReadingRepository);
  });

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should do nothing',
    build: () => createBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (BloodReadingPreviewBloc bloc) => bloc.add(
      const BloodReadingPreviewEventInitialize(
        bloodReadingId: 'br1',
      ),
    ),
    expect: () => [],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'initialize, '
    'should set listener of blood reading matching to given id',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      bloodReadingRepository.mockGetReadingById(
        bloodReading: createBloodReading(
          id: 'br1',
          date: DateTime(2023, 5, 1),
          parameters: const [
            BloodReadingParameter(
              parameter: BloodParameter.wbc,
              readingValue: 4.45,
            ),
            BloodReadingParameter(
              parameter: BloodParameter.cpk,
              readingValue: 300,
            ),
          ],
        ),
      );
    },
    act: (BloodReadingPreviewBloc bloc) => bloc.add(
      const BloodReadingPreviewEventInitialize(
        bloodReadingId: 'br1',
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        bloodReadingId: 'br1',
        date: DateTime(2023, 5, 1),
        readParameters: const [
          BloodReadingParameter(
            parameter: BloodParameter.wbc,
            readingValue: 4.45,
          ),
          BloodReadingParameter(
            parameter: BloodParameter.cpk,
            readingValue: 300,
          ),
        ],
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => bloodReadingRepository.getReadingById(
          bloodReadingId: 'br1',
          userId: 'u1',
        ),
      ).called(1);
    },
  );

  blocTest(
    'blood reading updated, '
    'should update date and read parameters in state',
    build: () => createBloc(),
    act: (BloodReadingPreviewBloc bloc) => bloc.add(
      BloodReadingPreviewEventBloodReadingUpdated(
        bloodReading: createBloodReading(
          id: 'br1',
          date: DateTime(2023, 5, 1),
          parameters: const [
            BloodReadingParameter(
              parameter: BloodParameter.wbc,
              readingValue: 4.45,
            ),
            BloodReadingParameter(
              parameter: BloodParameter.cpk,
              readingValue: 300,
            ),
          ],
        ),
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        bloodReadingId: 'br1',
        date: DateTime(2023, 5, 1),
        readParameters: const [
          BloodReadingParameter(
            parameter: BloodParameter.wbc,
            readingValue: 4.45,
          ),
          BloodReadingParameter(
            parameter: BloodParameter.cpk,
            readingValue: 300,
          ),
        ],
      ),
    ],
  );

  blocTest(
    'delete reading, '
    'blood reading id is null, '
    'should do nothing',
    build: () => createBloc(),
    act: (BloodReadingPreviewBloc bloc) => bloc.add(
      const BloodReadingPreviewEventDeleteReading(),
    ),
    expect: () => [],
  );

  blocTest(
    'delete reading, '
    'logged user does not exist, '
    'should emit no logged user info',
    build: () => createBloc(
      bloodReadingId: 'br1',
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (BloodReadingPreviewBloc bloc) => bloc.add(
      const BloodReadingPreviewEventDeleteReading(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusNoLoggedUser(),
        bloodReadingId: 'br1',
      ),
    ],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'delete reading, '
    'should call method from blood reading repository to delete blood reading and should emit info that blood reading has been deleted',
    build: () => createBloc(
      bloodReadingId: 'br1',
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      bloodReadingRepository.mockDeleteReading();
    },
    act: (BloodReadingPreviewBloc bloc) => bloc.add(
      const BloodReadingPreviewEventDeleteReading(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        bloodReadingId: 'br1',
      ),
      createState(
        status: const BlocStatusComplete<BloodReadingPreviewBlocInfo>(
          info: BloodReadingPreviewBlocInfo.bloodReadingDeleted,
        ),
        bloodReadingId: 'br1',
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => bloodReadingRepository.deleteReading(
          bloodReadingId: 'br1',
          userId: 'u1',
        ),
      ).called(1);
    },
  );
}
