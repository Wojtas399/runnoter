import 'package:equatable/equatable.dart';

import 'bloc_status.dart';

abstract class CubitState<State> extends Equatable {
  final BlocStatus status;

  const CubitState({required this.status});

  @override
  List<Object?> get props => [status];

  State copyWith({BlocStatus? status});
}
