import 'package:equatable/equatable.dart';

class ElementsFromYear<T> extends Equatable {
  final int year;
  final List<T> elements;

  const ElementsFromYear({required this.year, required this.elements});

  @override
  List<Object?> get props => [year, elements];
}
