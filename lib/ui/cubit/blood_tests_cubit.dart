import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/blood_test.dart';
import '../../data/repository/blood_test/blood_test_repository.dart';
import '../../dependency_injection.dart';
import '../model/elements_from_year.dart';

class BloodTestsCubit extends Cubit<List<BloodTestsFromYear>?> {
  final String userId;
  final BloodTestRepository _bloodTestRepository;
  StreamSubscription<List<BloodTest>?>? _bloodTestsListener;

  BloodTestsCubit({required this.userId})
      : _bloodTestRepository = getIt<BloodTestRepository>(),
        super(null);

  @override
  Future<void> close() {
    _bloodTestsListener?.cancel();
    _bloodTestsListener = null;
    return super.close();
  }

  void initialize() {
    _bloodTestsListener ??= _bloodTestRepository
        .getTestsByUserId(userId: userId)
        .listen(_onBloodTestsChanged);
  }

  Future<void> refresh() async {
    await _bloodTestRepository.refreshTestsByUserId(userId: userId);
  }

  void _onBloodTestsChanged(final List<BloodTest>? bloodTests) {
    if (bloodTests == null) {
      emit([]);
      return;
    }
    final groupedAndSortedTests = _groupBloodTests(bloodTests);
    groupedAndSortedTests.sort((t1, t2) => t2.year < t1.year ? -1 : 1);
    for (final testsFromYear in groupedAndSortedTests) {
      testsFromYear.elements.sort((t1, t2) => t2.date.compareTo(t1.date));
    }
    emit(groupedAndSortedTests);
  }

  List<BloodTestsFromYear> _groupBloodTests(List<BloodTest> bloodTests) {
    final List<BloodTestsFromYear> groupedTests = [];
    for (final test in bloodTests) {
      final int year = test.date.year;
      final int yearIndex = groupedTests.indexWhere(
        (element) => element.year == year,
      );
      if (yearIndex >= 0) {
        groupedTests[yearIndex].elements.add(test);
      } else {
        groupedTests.add(
          BloodTestsFromYear(year: year, elements: [test]),
        );
      }
    }
    return groupedTests;
  }
}

class BloodTestsFromYear extends ElementsFromYear<BloodTest> {
  const BloodTestsFromYear({required super.year, required super.elements});
}
