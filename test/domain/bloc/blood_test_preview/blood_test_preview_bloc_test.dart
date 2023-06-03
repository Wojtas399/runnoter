import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/bloc/blood_test_preview/blood_test_preview_bloc.dart';
import 'package:runnoter/domain/model/blood_parameter.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';

import '../../../mock/domain/mock_auth_service.dart';
import '../../../mock/domain/mock_blood_test_repository.dart';
import '../../../util/blood_test_creator.dart';

void main() {
  final authService = MockAuthService();
  final bloodTestRepository = MockBloodTestRepository();

  BloodTestPreviewBloc createBloc({
    String? bloodTestId,
  }) =>
      BloodTestPreviewBloc(
        authService: authService,
        bloodTestRepository: bloodTestRepository,
        state: BloodTestPreviewState(
          status: const BlocStatusInitial(),
          bloodTestId: bloodTestId,
        ),
      );

  BloodTestPreviewState createState({
    BlocStatus status = const BlocStatusInitial(),
    String? bloodTestId,
    DateTime? date,
    List<BloodParameterResult>? parameterResults,
  }) =>
      BloodTestPreviewState(
        status: status,
        bloodTestId: bloodTestId,
        date: date,
        parameterResults: parameterResults,
      );

  tearDown(() {
    reset(authService);
    reset(bloodTestRepository);
  });

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should do nothing',
    build: () => createBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (BloodTestPreviewBloc bloc) => bloc.add(
      const BloodTestPreviewEventInitialize(
        bloodTestId: 'br1',
      ),
    ),
    expect: () => [],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'initialize, '
    'should set listener of blood test matching to given id',
    build: () => createBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      bloodTestRepository.mockGetTestById(
        bloodTest: createBloodTest(
          id: 'br1',
          date: DateTime(2023, 5, 1),
          parameterResults: const [
            BloodParameterResult(
              parameter: BloodParameter.wbc,
              value: 4.45,
            ),
            BloodParameterResult(
              parameter: BloodParameter.cpk,
              value: 300,
            ),
          ],
        ),
      );
    },
    act: (BloodTestPreviewBloc bloc) => bloc.add(
      const BloodTestPreviewEventInitialize(
        bloodTestId: 'br1',
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        bloodTestId: 'br1',
        date: DateTime(2023, 5, 1),
        parameterResults: const [
          BloodParameterResult(
            parameter: BloodParameter.wbc,
            value: 4.45,
          ),
          BloodParameterResult(
            parameter: BloodParameter.cpk,
            value: 300,
          ),
        ],
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => bloodTestRepository.getTestById(
          bloodTestId: 'br1',
          userId: 'u1',
        ),
      ).called(1);
    },
  );

  blocTest(
    'blood test updated, '
    'should update date and parameter results in state',
    build: () => createBloc(),
    act: (BloodTestPreviewBloc bloc) => bloc.add(
      BloodTestPreviewEventBloodTestUpdated(
        bloodTest: createBloodTest(
          id: 'br1',
          date: DateTime(2023, 5, 1),
          parameterResults: const [
            BloodParameterResult(
              parameter: BloodParameter.wbc,
              value: 4.45,
            ),
            BloodParameterResult(
              parameter: BloodParameter.cpk,
              value: 300,
            ),
          ],
        ),
      ),
    ),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        bloodTestId: 'br1',
        date: DateTime(2023, 5, 1),
        parameterResults: const [
          BloodParameterResult(
            parameter: BloodParameter.wbc,
            value: 4.45,
          ),
          BloodParameterResult(
            parameter: BloodParameter.cpk,
            value: 300,
          ),
        ],
      ),
    ],
  );

  blocTest(
    'delete test, '
    'blood test id is null, '
    'should do nothing',
    build: () => createBloc(),
    act: (BloodTestPreviewBloc bloc) => bloc.add(
      const BloodTestPreviewEventDeleteTest(),
    ),
    expect: () => [],
  );

  blocTest(
    'delete test, '
    'logged user does not exist, '
    'should emit no logged user info',
    build: () => createBloc(
      bloodTestId: 'br1',
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (BloodTestPreviewBloc bloc) => bloc.add(
      const BloodTestPreviewEventDeleteTest(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusNoLoggedUser(),
        bloodTestId: 'br1',
      ),
    ],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'delete test, '
    'should call method from blood test repository to delete blood test and should emit info that blood test has been deleted',
    build: () => createBloc(
      bloodTestId: 'br1',
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      bloodTestRepository.mockDeleteTest();
    },
    act: (BloodTestPreviewBloc bloc) => bloc.add(
      const BloodTestPreviewEventDeleteTest(),
    ),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        bloodTestId: 'br1',
      ),
      createState(
        status: const BlocStatusComplete<BloodTestPreviewBlocInfo>(
          info: BloodTestPreviewBlocInfo.bloodTestDeleted,
        ),
        bloodTestId: 'br1',
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => bloodTestRepository.deleteTest(
          bloodTestId: 'br1',
          userId: 'u1',
        ),
      ).called(1);
    },
  );
}
