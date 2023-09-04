import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/date_service.dart';
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
import '../../service/auth_service.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc
    extends BlocWithStatus<ChatEvent, ChatState, ChatBlocInfo, dynamic> {
  final String _chatId;
  final AuthService _authService;
  final ChatRepository _chatRepository;
  final MessageRepository _messageRepository;
  final PersonRepository _personRepository;
  final DateService _dateService;

  ChatBloc({
    required String chatId,
    ChatState initialState = const ChatState(status: BlocStatusInitial()),
  })  : _chatId = chatId,
        _authService = getIt<AuthService>(),
        _chatRepository = getIt<ChatRepository>(),
        _messageRepository = getIt<MessageRepository>(),
        _personRepository = getIt<PersonRepository>(),
        _dateService = getIt<DateService>(),
        super(initialState) {
    on<ChatEventInitialize>(_initialize, transformer: restartable());
    on<ChatEventMessageChanged>(_messageChanged);
    on<ChatEventSubmitMessage>(_submitMessage);
  }

  Future<void> _initialize(
    ChatEventInitialize event,
    Emitter<ChatState> emit,
  ) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) return;
    final Chat chat =
        await _chatRepository.getChatById(chatId: _chatId).whereNotNull().first;
    final Person sender = await _personRepository
        .getPersonById(personId: loggedUserId)
        .whereNotNull()
        .first;
    final Person recipient = await _personRepository
        .getPersonById(
          personId: chat.user1Id == loggedUserId ? chat.user2Id : chat.user1Id,
        )
        .whereNotNull()
        .first;
    await emit.forEach(
      _messageRepository.getMessagesForChat(chatId: _chatId),
      onData: (List<Message> messages) {
        final List<Message> sortedMessages = [...messages];
        sortedMessages.sort(
          (m1, m2) => m1.dateTime.isBefore(m2.dateTime) ? 1 : -1,
        );
        return state.copyWith(
          loggedUserId: loggedUserId,
          senderFullName: '${sender.name} ${sender.surname}',
          recipientFullName: '${recipient.name} ${recipient.surname}',
          messages: sortedMessages,
        );
      },
    );
  }

  void _messageChanged(
    ChatEventMessageChanged event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(
      messageToSend: event.message,
    ));
  }

  Future<void> _submitMessage(
    ChatEventSubmitMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (!state.canSubmitMessage) return;
    final DateTime now = _dateService.getNow();
    emitLoadingStatus(emit);
    await _messageRepository.addMessageToChat(
      chatId: _chatId,
      senderId: state.loggedUserId!,
      content: state.messageToSend!,
      dateTime: now,
    );
    emit(state.copyWith(
      status: const BlocStatusComplete<ChatBlocInfo>(
        info: ChatBlocInfo.messageSent,
      ),
      messageToSendAsNull: true,
    ));
  }
}

enum ChatBlocInfo { messageSent }
