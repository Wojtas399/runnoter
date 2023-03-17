import 'package:equatable/equatable.dart';

abstract class BlocStatus extends Equatable {
  const BlocStatus();

  @override
  List<Object> get props => [];
}

class BlocStatusInitial extends BlocStatus {
  const BlocStatusInitial();
}

class BlocStatusLoading extends BlocStatus {
  const BlocStatusLoading();
}

class BlocStatusComplete<T> extends BlocStatus {
  final T? info;

  const BlocStatusComplete({
    this.info,
  });
}

class BlocStatusError<T> extends BlocStatus {
  final T error;

  const BlocStatusError({
    required this.error,
  });
}

class BlocStatusUnknownError extends BlocStatus {
  const BlocStatusUnknownError();
}

class BlocStatusNoInternetConnection extends BlocStatus {
  const BlocStatusNoInternetConnection();
}
