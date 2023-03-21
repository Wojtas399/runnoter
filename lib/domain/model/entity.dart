import 'package:equatable/equatable.dart';

abstract class Entity extends Equatable {
  final String id;

  const Entity({
    required this.id,
  });

  @override
  List<Object> get props => [
        id,
      ];
}
