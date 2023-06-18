import 'package:equatable/equatable.dart';

abstract class BlocStatus extends Equatable {
  const BlocStatus();

  @override
  List<Object?> get props => [];
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

  @override
  List<Object?> get props => [
        info,
      ];
}

class BlocStatusError<T> extends BlocStatus {
  final T error;

  const BlocStatusError({
    required this.error,
  });

  @override
  List<Object?> get props => [
        error,
      ];
}

class BlocStatusUnknownError extends BlocStatus {
  const BlocStatusUnknownError();
}

class BlocStatusNetworkRequestFailed extends BlocStatus {
  const BlocStatusNetworkRequestFailed();
}

class BlocStatusNoLoggedUser extends BlocStatus {
  const BlocStatusNoLoggedUser();
}
