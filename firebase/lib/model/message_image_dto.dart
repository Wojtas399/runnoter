import 'package:equatable/equatable.dart';

class MessageImageDto extends Equatable {
  final String id;
  final String messageId;
  final DateTime sendDateTime;
  final int order;

  const MessageImageDto({
    required this.id,
    required this.messageId,
    required this.sendDateTime,
    required this.order,
  });

  MessageImageDto.fromJson({
    required final String messageImageId,
    required final Map<String, dynamic>? json,
  }) : this(
          id: messageImageId,
          messageId: json?[messageIdField],
          sendDateTime: DateTime.fromMillisecondsSinceEpoch(
            json?[sendTimestampField],
          ),
          order: json?[_orderField],
        );

  @override
  List<Object?> get props => [id, order];

  Map<String, dynamic> toJson() => {
        messageIdField: messageId,
        sendTimestampField: sendDateTime.millisecondsSinceEpoch,
        _orderField: order,
      };
}

const String messageIdField = 'messageId';
const String sendTimestampField = 'sendTimestamp';
const String _orderField = 'order';
