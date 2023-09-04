import 'package:equatable/equatable.dart';

class ChatDto extends Equatable {
  final String id;
  final String user1Id;
  final String user2Id;

  const ChatDto({
    required this.id,
    required this.user1Id,
    required this.user2Id,
  }) : assert(user1Id != user2Id);

  ChatDto.fromJson({
    required String chatId,
    required Map<String, dynamic>? json,
  }) : this(
          id: chatId,
          user1Id: json?[user1IdField],
          user2Id: json?[user2IdField],
        );

  @override
  List<Object?> get props => [id, user1Id, user2Id];

  Map<String, dynamic> toJson() => {
        user1IdField: user1Id,
        user2IdField: user2Id,
      };
}

const String user1IdField = 'user1Id';
const String user2IdField = 'user2Id';
