import 'package:equatable/equatable.dart';

class CoachingRequestDto extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final bool isAccepted;

  const CoachingRequestDto({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.isAccepted,
  }) : assert(senderId != receiverId);

  @override
  List<Object?> get props => [id, senderId, receiverId, isAccepted];

  CoachingRequestDto.fromJson({
    required String coachingRequestId,
    required Map<String, dynamic>? json,
  }) : this(
          id: coachingRequestId,
          senderId: json?[senderIdField],
          receiverId: json?[receiverIdField],
          isAccepted: json?[isAcceptedField],
        );

  Map<String, dynamic> toJson() => {
        senderIdField: senderId,
        receiverIdField: receiverId,
        isAcceptedField: isAccepted,
      };
}

const String senderIdField = 'senderId';
const String receiverIdField = 'receiverId';
const String isAcceptedField = 'isAccepted';
