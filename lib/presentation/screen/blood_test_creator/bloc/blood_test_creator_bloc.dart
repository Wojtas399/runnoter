import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/model/blood_test_parameter.dart';
import '../../../../domain/repository/blood_test_repository.dart';
import '../../../model/bloc_state.dart';
import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';

part 'blood_test_creator_event.dart';
part 'blood_test_creator_state.dart';

class BloodTestCreatorBloc extends BlocWithStatus<BloodTestCreatorEvent,
    BloodTestCreatorState, dynamic, dynamic> {
  final BloodTestRepository _bloodTestRepository;

  BloodTestCreatorBloc({
    required BloodTestRepository bloodTestRepository,
    BlocStatus status = const BlocStatusInitial(),
    List<BloodTestParameter>? parameters,
  })  : _bloodTestRepository = bloodTestRepository,
        super(
          BloodTestCreatorState(
            status: status,
            parameters: parameters,
          ),
        ) {
    on<BloodTestCreatorEventInitialize>(_initialize);
  }

  Future<void> _initialize(
    BloodTestCreatorEventInitialize event,
    Emitter<BloodTestCreatorState> emit,
  ) async {
    final List<BloodTestParameter>? parameters =
        await _bloodTestRepository.loadAllParameters();
    emit(state.copyWith(
      parameters: parameters,
    ));
  }
}
