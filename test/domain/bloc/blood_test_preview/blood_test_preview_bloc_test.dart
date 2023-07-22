import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/blood_test_preview/blood_test_preview_bloc.dart';
import 'package:runnoter/domain/entity/blood_parameter.dart';
import 'package:runnoter/domain/entity/user.dart';

import '../../../creators/blood_test_creator.dart';
import '../../../mock/domain/repository/mock_blood_test_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';
import '../../../mock/domain/use_case/mock_get_logged_user_gender_use_case.dart';

void main() {
  final authService = MockAuthService();
  final getLoggedUserGenderUseCase = MockGetLoggedUserGenderUseCase();
  final bloodTestRepository = MockBloodTestRepository();
  const String loggedUserId = 'u1';
  const String bloodTestId = 'b1';

  BloodTestPreviewBloc createBloc({
    String? bloodTestId,
  }) =>
      BloodTestPreviewBloc(
        authService: authService,
        getLoggedUserGenderUseCase: getLoggedUserGenderUseCase,
        bloodTestRepository: bloodTestRepository,
        bloodTestId: bloodTestId,
        state: const BloodTestPreviewState(
          status: BlocStatusInitial(),
        ),
      );

  BloodTestPreviewState createState({
    BlocStatus status = const BlocStatusInitial(),
    DateTime? date,
    Gender? gender,
    List<BloodParameterResult>? parameterResults,
  }) =>
      BloodTestPreviewState(
        status: status,
        date: date,
        gender: gender,
        parameterResults: parameterResults,
      );

  tearDown(() {
    reset(authService);
    reset(getLoggedUserGenderUseCase);
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
    "should set listener of logged user's gender and blood test matching to given id",
    build: () => createBloc(bloodTestId: bloodTestId),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      getLoggedUserGenderUseCase.mock(gender: Gender.male);
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
        gender: Gender.male,
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
        () => getLoggedUserGenderUseCase.execute(),
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
