import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/model/blood_parameter.dart';
import 'package:runnoter/domain/model/blood_reading.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/blood_reading_creator/bloc/blood_reading_creator_bloc.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_blood_reading_repository.dart';

void main() {
  final authService = MockAuthService();
  final bloodReadingRepository = MockBloodReadingRepository();

  BloodReadingCreatorBloc createBloc({
    DateTime? date,
    List<BloodReadingParameter>? bloodReadingParameters,
  }) =>
      BloodReadingCreatorBloc(
        authService: authService,
        bloodReadingRepository: bloodReadingRepository,
        date: date,
        bloodReadingParameters: bloodReadingParameters,
      );

  BloodReadingCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    DateTime? date,
    List<BloodReadingParameter>? bloodReadingParameters,
  }) =>
      BloodReadingCreatorState(
        status: status,
        date: date,
        bloodReadingParameters: bloodReadingParameters,
      );

  tearDown(() {
    reset(authService);
    reset(bloodReadingRepository);
  });

  blocTest(
    'date changed, '
    'should update date in state',
    build: () => createBloc(),
    act: (BloodReadingCreatorBloc bloc) => bloc.add(
      BloodReadingCreatorEventDateChanged(
        date: DateTime(2023, 5, 20),
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        date: DateTime(2023, 5, 20),
      ),
    ],
  );

  blocTest(
    'blood reading parameter changed, '
    'parameter exists in state, '
    'should update parameter value',
    build: () => createBloc(
      bloodReadingParameters: const [
        BloodReadingParameter(
          parameter: BloodParameter.wbc,
          readingValue: 4.50,
        ),
        BloodReadingParameter(
          parameter: BloodParameter.sodium,
          readingValue: 140,
        ),
      ],
    ),
    act: (BloodReadingCreatorBloc bloc) => bloc.add(
      const BloodReadingCreatorEventBloodReadingParameterChanged(
        bloodParameter: BloodParameter.wbc,
        parameterValue: 4.45,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        bloodReadingParameters: const [
          BloodReadingParameter(
            parameter: BloodParameter.wbc,
            readingValue: 4.45,
          ),
          BloodReadingParameter(
            parameter: BloodParameter.sodium,
            readingValue: 140,
          ),
        ],
      ),
    ],
  );

  blocTest(
    'blood reading parameter changed, '
    'parameter does not exist in state, '
    'should add parameter to list',
    build: () => createBloc(
      bloodReadingParameters: const [
        BloodReadingParameter(
          parameter: BloodParameter.wbc,
          readingValue: 4.50,
        ),
      ],
    ),
    act: (BloodReadingCreatorBloc bloc) => bloc.add(
      const BloodReadingCreatorEventBloodReadingParameterChanged(
        bloodParameter: BloodParameter.sodium,
        parameterValue: 140,
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        bloodReadingParameters: const [
          BloodReadingParameter(
            parameter: BloodParameter.wbc,
            readingValue: 4.50,
          ),
          BloodReadingParameter(
            parameter: BloodParameter.sodium,
            readingValue: 140,
          ),
        ],
      ),
    ],
  );

  blocTest(
    'submit, '
    'data are invalid, '
    'should finish event call',
    build: () => createBloc(),
    act: (BloodReadingCreatorBloc bloc) => bloc.add(
      const BloodReadingCreatorEventSubmit(),
    ),
    expect: () => [],
  );

  blocTest(
    'submit, '
    'logged user does not exist, '
    'should emit no logged user status',
    build: () => createBloc(
      date: DateTime(2023, 5, 20),
      bloodReadingParameters: const [
        BloodReadingParameter(
          parameter: BloodParameter.wbc,
          readingValue: 4.45,
        ),
      ],
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (BloodReadingCreatorBloc bloc) => bloc.add(
      const BloodReadingCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusNoLoggedUser(),
        date: DateTime(2023, 5, 20),
        bloodReadingParameters: const [
          BloodReadingParameter(
            parameter: BloodParameter.wbc,
            readingValue: 4.45,
          ),
        ],
      ),
    ],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'submit, '
    'should call method from blood reading repository to add new reading and should emit info about added reading',
    build: () => createBloc(
      date: DateTime(2023, 5, 20),
      bloodReadingParameters: const [
        BloodReadingParameter(
          parameter: BloodParameter.wbc,
          readingValue: 4.45,
        ),
        BloodReadingParameter(
          parameter: BloodParameter.sodium,
          readingValue: 139,
        ),
      ],
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      bloodReadingRepository.mockAddNewReading();
    },
    act: (BloodReadingCreatorBloc bloc) => bloc.add(
      const BloodReadingCreatorEventSubmit(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        date: DateTime(2023, 5, 20),
        bloodReadingParameters: const [
          BloodReadingParameter(
            parameter: BloodParameter.wbc,
            readingValue: 4.45,
          ),
          BloodReadingParameter(
            parameter: BloodParameter.sodium,
            readingValue: 139,
          ),
        ],
      ),
      createState(
        status: const BlocStatusComplete<BloodReadingCreatorBlocInfo>(
          info: BloodReadingCreatorBlocInfo.bloodReadingAdded,
        ),
        date: DateTime(2023, 5, 20),
        bloodReadingParameters: const [
          BloodReadingParameter(
            parameter: BloodParameter.wbc,
            readingValue: 4.45,
          ),
          BloodReadingParameter(
            parameter: BloodParameter.sodium,
            readingValue: 139,
          ),
        ],
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => bloodReadingRepository.addNewReading(
          userId: 'u1',
          date: DateTime(2023, 5, 20),
          parameters: const [
            BloodReadingParameter(
              parameter: BloodParameter.wbc,
              readingValue: 4.45,
            ),
            BloodReadingParameter(
              parameter: BloodParameter.sodium,
              readingValue: 139,
            ),
          ],
        ),
      ).called(1);
    },
  );
}
