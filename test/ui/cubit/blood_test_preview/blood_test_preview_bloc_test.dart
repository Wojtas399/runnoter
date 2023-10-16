import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/entity/user.dart';
import 'package:runnoter/data/interface/repository/blood_test_repository.dart';
import 'package:runnoter/data/interface/repository/user_repository.dart';
import 'package:runnoter/data/model/blood_test.dart';
import 'package:runnoter/ui/cubit/blood_test_preview/blood_test_preview_cubit.dart';

import '../../../creators/blood_test_creator.dart';
import '../../../creators/user_creator.dart';
import '../../../mock/domain/repository/mock_blood_test_repository.dart';
import '../../../mock/domain/repository/mock_user_repository.dart';

void main() {
  final userRepository = MockUserRepository();
  final bloodTestRepository = MockBloodTestRepository();
  const String userId = 'u1';
  const String bloodTestId = 'b1';

  BloodTestPreviewCubit createCubit() =>
      BloodTestPreviewCubit(userId: userId, bloodTestId: bloodTestId);

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
        build: () => createCubit(),
        setUp: () {
          userRepository.mockGetUserById(userStream: user$.stream);
          bloodTestRepository.mockGetTestById(
            bloodTestStream: bloodTest$.stream,
          );
        },
        act: (cubit) {
          cubit.initialize();
          user$.add(updatedUser);
          bloodTest$.add(updatedBloodTest);
        },
        expect: () => [
          BloodTestPreviewState(
            date: bloodTest.date,
            gender: user.gender,
            parameterResults: bloodTest.parameterResults,
          ),
          BloodTestPreviewState(
            date: bloodTest.date,
            gender: updatedUser.gender,
            parameterResults: bloodTest.parameterResults,
          ),
          BloodTestPreviewState(
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
    'should call method from blood test repository to delete blood test',
    build: () => createCubit(),
    setUp: () => bloodTestRepository.mockDeleteTest(),
    act: (cubit) => cubit.deleteTest(),
    expect: () => [],
    verify: (_) => verify(
      () => bloodTestRepository.deleteTest(
        bloodTestId: bloodTestId,
        userId: userId,
      ),
    ).called(1),
  );
}
