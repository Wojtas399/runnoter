import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dependency_injection.dart';
import '../additional_model/elements_from_year.dart';
import '../entity/blood_test.dart';
import '../repository/blood_test_repository.dart';

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
        .getAllTests(userId: userId)
        .listen(_onBloodTestsChanged);
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
