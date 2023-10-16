import 'package:equatable/equatable.dart';

abstract class CubitStatus extends Equatable {
  const CubitStatus();

  @override
  List<Object?> get props => [];
}

class CubitStatusInitial extends CubitStatus {
  const CubitStatusInitial();
}

class CubitStatusLoading<T> extends CubitStatus {
  final T? loadingInfo;

  const CubitStatusLoading({this.loadingInfo});

  @override
  List<Object?> get props => [loadingInfo];
}

class CubitStatusComplete<T> extends CubitStatus {
  final T? info;

  const CubitStatusComplete({this.info});

  @override
  List<Object?> get props => [info];
}

class CubitStatusError<T> extends CubitStatus {
  final T error;

  const CubitStatusError({required this.error});

  @override
  List<Object?> get props => [error];
}

class CubitStatusUnknownError extends CubitStatus {
  const CubitStatusUnknownError();
}

class CubitStatusNoInternetConnection extends CubitStatus {
  const CubitStatusNoInternetConnection();
}

class CubitStatusNoLoggedUser extends CubitStatus {
  const CubitStatusNoLoggedUser();
}
