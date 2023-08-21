import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/cubit/blood_tests_cubit.dart';
import 'package:runnoter/domain/entity/blood_test.dart';
import 'package:runnoter/domain/repository/blood_test_repository.dart';

import '../../creators/blood_test_creator.dart';
import '../../mock/domain/repository/mock_blood_test_repository.dart';

void main() {
  final bloodTestRepository = MockBloodTestRepository();
  const String userId = 'u1';

  setUpAll(() {
    GetIt.I.registerSingleton<BloodTestRepository>(bloodTestRepository);
  });

  tearDown(() {
    reset(bloodTestRepository);
  });

  group(
    'initialize',
    () {
      final List<BloodTest> tests = [
        createBloodTest(id: 'br2', date: DateTime(2023, 2, 10)),
        createBloodTest(id: 'br3', date: DateTime(2022, 4, 10)),
        createBloodTest(id: 'br1', date: DateTime(2023, 5, 20)),
        createBloodTest(id: 'br4', date: DateTime(2021, 7, 10)),
      ];
      final StreamController<List<BloodTest>> tests$ = StreamController()
        ..add(tests);

      blocTest(
        'should set listener of blood tests and should group and sort races by date',
        build: () => BloodTestsCubit(userId: userId),
        setUp: () => bloodTestRepository.mockGetAllTests(
          testsStream: tests$.stream,
        ),
        act: (cubit) async {
          cubit.initialize();
          await cubit.stream.first;
          tests$.add([tests[1]]);
        },
        expect: () => [
          [
            BloodTestsFromYear(year: 2023, elements: [tests.first, tests[2]]),
            BloodTestsFromYear(year: 2022, elements: [tests[1]]),
            BloodTestsFromYear(year: 2021, elements: [tests.last]),
          ],
          [
            BloodTestsFromYear(year: 2022, elements: [tests[1]]),
          ],
        ],
        verify: (_) => verify(
          () => bloodTestRepository.getAllTests(userId: userId),
        ).called(1),
      );
    },
  );
}
