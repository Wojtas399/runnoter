import 'entity.dart';

class PulseAndWeight extends Entity {
  final int pulse;
  final double weight;

  PulseAndWeight({
    required DateTime date,
    required this.pulse,
    required this.weight,
  }) : super(
          id: '${date.year}-${date.month}-${date.day}',
        );

  @override
  List<Object?> get props => [
        id,
        pulse,
        weight,
      ];
}
