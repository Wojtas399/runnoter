import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/blood_parameter.dart';
import 'package:runnoter/domain/bloc/blood_test_preview/blood_test_preview_bloc.dart';
import 'package:runnoter/domain/entity/blood_test.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/repository/blood_test_repository.dart';
import 'package:runnoter/domain/repository/user_repository.dart';

import '../../../creators/blood_test_creator.dart';
import '../../../creators/user_creator.dart';
import '../../../mock/domain/repository/mock_blood_test_repository.dart';
import '../../../mock/domain/repository/mock_user_repository.dart';

void main() {
  final userRepository = MockUserRepository();
  final bloodTestRepository = MockBloodTestRepository();
  const String userId = 'u1';
  const String bloodTestId = 'b1';

  BloodTestPreviewBloc createBloc() =>
      BloodTestPreviewBloc(userId: userId, bloodTestId: bloodTestId);

  setUpAll(() {
    GetIt.I.registerFactory<UserRepository>(() => userRepository);
    GetIt.I.registerSingleton<BloodTestRepository>(bloodTestRepository);
  });

  tearDown(() {
    reset(userRepository);
    reset(bloodTestRepository);
  });

  group(
    'initialize',
    () {
      final User user = createUser(gender: Gender.male);
      final BloodTest bloodTest = createBloodTest(
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
      );
      final User updatedUser = createUser(gender: Gender.female);
      final BloodTest updatedBloodTest = createBloodTest(
        date: DateTime(2023, 5, 3),
        parameterResults: const [
          BloodParameterResult(
            parameter: BloodParameter.wbc,
            value: 4.40,
          ),
          BloodParameterResult(
            parameter: BloodParameter.cpk,
            value: 295,
          ),
        ],
      );
      final StreamController<User> user$ = StreamController()..add(user);
      final StreamController<BloodTest> bloodTest$ = StreamController()
        ..add(bloodTest);

      blocTest(
        "should set listener of user's gender and blood test matching to given test id",
        build: () => createBloc(),
        setUp: () {
          userRepository.mockGetUserById(userStream: user$.stream);
          bloodTestRepository.mockGetTestById(
            bloodTestStream: bloodTest$.stream,
          );
        },
        act: (bloc) {
          bloc.add(const BloodTestPreviewEventInitialize());
          user$.add(updatedUser);
          bloodTest$.add(updatedBloodTest);
        },
        expect: () => [
          BloodTestPreviewState(
            status: const BlocStatusComplete(),
            date: bloodTest.date,
            gender: user.gender,
            parameterResults: bloodTest.parameterResults,
          ),
          BloodTestPreviewState(
            status: const BlocStatusComplete(),
            date: updatedBloodTest.date,
            gender: updatedUser.gender,
            parameterResults: updatedBloodTest.parameterResults,
          ),
        ],
        verify: (_) {
          verify(() => userRepository.getUserById(userId: userId)).called(1);
          verify(
            () => bloodTestRepository.getTestById(
              bloodTestId: bloodTestId,
              userId: userId,
            ),
          ).called(1);
        },
      );
    },
  );

  blocTest(
    'delete test, '
    'should call method from blood test repository to delete blood test and '
    'should emit info that blood test has been deleted',
    build: () => createBloc(),
    setUp: () => bloodTestRepository.mockDeleteTest(),
    act: (bloc) => bloc.add(const BloodTestPreviewEventDeleteTest()),
    expect: () => [
      const BloodTestPreviewState(status: BlocStatusLoading()),
      const BloodTestPreviewState(
        status: BlocStatusComplete<BloodTestPreviewBlocInfo>(
          info: BloodTestPreviewBlocInfo.bloodTestDeleted,
        ),
      ),
    ],
    verify: (_) => verify(
      () => bloodTestRepository.deleteTest(
        bloodTestId: bloodTestId,
        userId: userId,
      ),
    ).called(1),
  );
}
