import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../dependency_injection.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/bloc_with_status.dart';
import '../../entity/chat.dart';
import '../../entity/message.dart';
import '../../entity/person.dart';
import '../../repository/chat_repository.dart';
import '../../repository/message_repository.dart';
import '../../repository/person_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends BlocWithStatus<ChatEvent, ChatState, dynamic, dynamic> {
  final String _senderId;
  final String _recipientId;
  final ChatRepository _chatRepository;
  final MessageRepository _messageRepository;
  final PersonRepository _personRepository;

  ChatBloc({
    required String senderId,
    required String recipientId,
    ChatState initialState = const ChatState(status: BlocStatusInitial()),
  })  : _senderId = senderId,
        _recipientId = recipientId,
        _chatRepository = getIt<ChatRepository>(),
        _messageRepository = getIt<MessageRepository>(),
        _personRepository = getIt<PersonRepository>(),
        super(initialState) {
    on<ChatEventInitialize>(_initialize, transformer: restartable());
  }

  Future<void> _initialize(
    ChatEventInitialize event,
    Emitter<ChatState> emit,
  ) async {
    final Person? sender =
        await _personRepository.getPersonById(personId: _senderId).first;
    final Person? recipient =
        await _personRepository.getPersonById(personId: _recipientId).first;
    if (sender == null || recipient == null) return;
    final Stream<List<Message>?> messages$ = _chatRepository
        .getChatByUsers(user1Id: _senderId, user2Id: _recipientId)
        .whereNotNull()
        .switchMap(
          (Chat chat) => _messageRepository.getMessagesForChat(chatId: chat.id),
        );
    await emit.forEach(
      messages$,
      onData: (List<Message>? messages) => state.copyWith(
        senderFullName: '${sender.name} ${sender.surname}',
        recipientFullName: '${recipient.name} ${recipient.surname}',
        messages: messages,
      ),
    );
  }
}
