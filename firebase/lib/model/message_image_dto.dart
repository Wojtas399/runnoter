import 'package:equatable/equatable.dart';

class MessageImageDto extends Equatable {
  final String id;
  final int order;

  const MessageImageDto({required this.id, required this.order});

  MessageImageDto.fromJson(final Map<String, dynamic>? json)
      : this(
          id: json?[_idField],
          order: json?[_orderField],
        );

  @override
  List<Object?> get props => [id, order];

  Map<String, dynamic> toJson() => {
        _idField: id,
        _orderField: order,
      };
}

const String _idField = 'id';
const String _orderField = 'order';
