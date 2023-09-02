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
    on<ChatEventSentMessage>(_sentMessage);
  }

  Future<void> _initialize(
    ChatEventInitialize event,
    Emitter<ChatState> emit,
  ) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) return;
    final Chat chat =
        await _chatRepository.getChatById(chatId: _chatId).whereNotNull().first;
    final (Person, Person) persons =
        await _loadPersonsById(chat.user1Id, chat.user2Id);
    final Person sender =
        persons.$1.id == loggedUserId ? persons.$1 : persons.$2;
    final Person recipient =
        persons.$1.id != loggedUserId ? persons.$1 : persons.$2;
    await emit.forEach(
      _messageRepository.getMessagesForChat(chatId: _chatId),
      onData: (List<Message>? messages) => state.copyWith(
        loggedUserId: loggedUserId,
        senderFullName: '${sender.name} ${sender.surname}',
        recipientFullName: '${recipient.name} ${recipient.surname}',
        messages: messages,
      ),
    );
  }

  Future<void> _sentMessage(
    ChatEventSentMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (state.loggedUserId == null) return;
    final DateTime now = _dateService.getNow();
    emitLoadingStatus(emit);
    await _messageRepository.addMessageToChat(
      chatId: _chatId,
      senderId: state.loggedUserId!,
      content: event.message,
      dateTime: now,
    );
    emitCompleteStatus(emit, info: ChatBlocInfo.messageSent);
  }

  Future<(Person, Person)> _loadPersonsById(
    String person1Id,
    String person2Id,
  ) async {
    final Stream<(Person, Person)> persons$ = Rx.combineLatest2(
      _personRepository.getPersonById(personId: person1Id).whereNotNull(),
      _personRepository.getPersonById(personId: person2Id).whereNotNull(),
      (Person person1, Person person2) => (person1, person2),
    );
    await for (final persons in persons$) {
      return persons;
    }
    throw '[CHAT BLOC] Cannot load persons';
  }
}

enum ChatBlocInfo { messageSent }
