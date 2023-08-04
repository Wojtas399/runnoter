import 'package:equatable/equatable.dart';

abstract class BlocStatus extends Equatable {
  const BlocStatus();

  @override
  List<Object?> get props => [];
}

class BlocStatusInitial extends BlocStatus {
  const BlocStatusInitial();
}

class BlocStatusLoading<T> extends BlocStatus {
  final T? loadingInfo;

  const BlocStatusLoading({this.loadingInfo});

  @override
  List<Object?> get props => [loadingInfo];
}

class BlocStatusComplete<T> extends BlocStatus {
  final T? info;

  const BlocStatusComplete({this.info});

  @override
  List<Object?> get props => [info];
}

class BlocStatusError<T> extends BlocStatus {
  final T error;

  const BlocStatusError({required this.error});

  @override
  List<Object?> get props => [error];
}

class BlocStatusUnknownError extends BlocStatus {
  const BlocStatusUnknownError();
}

class BlocStatusNoInternetConnection extends BlocStatus {
  const BlocStatusNoInternetConnection();
}

class BlocStatusNoLoggedUser extends BlocStatus {
  const BlocStatusNoLoggedUser();
}
