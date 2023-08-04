part of 'reauthentication_bloc.dart';

class ReauthenticationState extends BlocState<ReauthenticationState> {
  final String? password;

  const ReauthenticationState({required super.status, this.password});

  @override
  List<Object?> get props => [status, password];

  @override
  ReauthenticationState copyWith({
    BlocStatus? status,
    String? password,
  }) =>
      ReauthenticationState(
        status: status ?? const BlocStatusComplete(),
        password: password ?? this.password,
      );
}
