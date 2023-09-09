part of 'reauthentication_cubit.dart';

class ReauthenticationState extends CubitState<ReauthenticationState> {
  final String? password;

  const ReauthenticationState({required super.status, this.password});

  @override
  List<Object?> get props => [status, password];

  @override
  ReauthenticationState copyWith({
    CubitStatus? status,
    String? password,
  }) =>
      ReauthenticationState(
        status: status ?? const CubitStatusComplete(),
        password: password ?? this.password,
      );
}
