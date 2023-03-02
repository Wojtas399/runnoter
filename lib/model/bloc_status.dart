import 'package:equatable/equatable.dart';

abstract class BlocStatus extends Equatable {
  const BlocStatus();

  @override
  List<Object> get props => [];
}

class InitialBlocStatus extends BlocStatus {
  const InitialBlocStatus();
}

class LoadingBlocStatus extends BlocStatus {
  const LoadingBlocStatus();
}

class CompleteBlocStatus<T> extends BlocStatus {
  final T? info;

  const CompleteBlocStatus({
    this.info,
  });
}

class ErrorBlocStatus<T> extends BlocStatus {
  final T? error;

  const ErrorBlocStatus({
    this.error,
  });
}
