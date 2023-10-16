import 'package:equatable/equatable.dart';

import '../../domain/additional_model/cubit_status.dart';

abstract class CubitState<State> extends Equatable {
  final CubitStatus status;

  const CubitState({required this.status});

  @override
  List<Object?> get props => [status];

  State copyWith({CubitStatus? status});
}
