import 'package:equatable/equatable.dart';

class ChatDto extends Equatable {
  final String id;
  final String user1Id;
  final String user2Id;

  const ChatDto({
    required this.id,
    required this.user1Id,
    required this.user2Id,
  });

  ChatDto.fromJson({
    required String id,
    required Map<String, dynamic>? json,
  }) : this(
          id: id,
          user1Id: json?[_user1IdField],
          user2Id: json?[_user2IdField],
        );

  @override
  List<Object?> get props => [id, user1Id, user2Id];

  Map<String, dynamic> toJson() => {
        _user1IdField: user1Id,
        _user2IdField: user2Id,
      };
}

const String _user1IdField = 'user1Id';
const String _user2IdField = 'user2Id';
