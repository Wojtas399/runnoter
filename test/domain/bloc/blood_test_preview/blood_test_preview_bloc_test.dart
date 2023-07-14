import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/blood_test_preview/blood_test_preview_bloc.dart';
import 'package:runnoter/domain/entity/blood_parameter.dart';

import '../../../creators/blood_test_creator.dart';
import '../../../mock/domain/repository/mock_blood_test_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final bloodTestRepository = MockBloodTestRepository();
  const String loggedUserId = 'u1';
  const String bloodTestId = 'b1';

  BloodTestPreviewBloc createBloc({
    String? bloodTestId,
  }) =>
      BloodTestPreviewBloc(
        authService: authService,
        bloodTestRepository: bloodTestRepository,
        bloodTestId: bloodTestId,
        state: const BloodTestPreviewState(
          status: BlocStatusInitial(),
        ),
      );

  BloodTestPreviewState createState({
    BlocStatus status = const BlocStatusInitial(),
    DateTime? date,
    List<BloodParameterResult>? parameterResults,
  }) =>
      BloodTestPreviewState(
        status: status,
        date: date,
        parameterResults: parameterResults,
      );

  tearDown(() {
    reset(authService);
    reset(bloodTestRepository);
  });

  blocTest(
    'initialize, '
    'blood test is null, '
    'should do nothing',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const BloodTestPreviewEventInitialize()),
    expect: () => [],
  );

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should do nothing',
    build: () => createBloc(bloodTestId: bloodTestId),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const BloodTestPreviewEventInitialize()),
    expect: () => [],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'initialize, '
    'should set listener of blood test matching to given id',
    build: () => createBloc(bloodTestId: bloodTestId),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
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
    act: (bloc) => bloc.add(const BloodTestPreviewEventInitialize()),
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
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
          bloodTestId: bloodTestId,
          userId: loggedUserId,
        ),
      ).called(1);
    },
  );

  blocTest(
    'delete test, '
    'blood test id is null, '
    'should do nothing',
    build: () => createBloc(),
    act: (bloc) => bloc.add(const BloodTestPreviewEventDeleteTest()),
    expect: () => [],
  );

  blocTest(
    'delete test, '
    'logged user does not exist, '
    'should emit no logged user info',
    build: () => createBloc(bloodTestId: bloodTestId),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const BloodTestPreviewEventDeleteTest()),
    expect: () => [
      createState(
        status: const BlocStatusNoLoggedUser(),
      ),
    ],
    verify: (_) => verify(
      () => authService.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'delete test, '
    'should call method from blood test repository to delete blood test and should emit info that blood test has been deleted',
    build: () => createBloc(bloodTestId: bloodTestId),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      bloodTestRepository.mockDeleteTest();
    },
    act: (bloc) => bloc.add(const BloodTestPreviewEventDeleteTest()),
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusComplete<BloodTestPreviewBlocInfo>(
          info: BloodTestPreviewBlocInfo.bloodTestDeleted,
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => authService.loggedUserId$,
      ).called(1);
      verify(
        () => bloodTestRepository.deleteTest(
          bloodTestId: bloodTestId,
          userId: loggedUserId,
        ),
      ).called(1);
    },
  );
}
