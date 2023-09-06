import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/date_service.dart';
import '../../../dependency_injection.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../entity/chat.dart';
import '../../entity/message.dart';
import '../../entity/person.dart';
import '../../repository/chat_repository.dart';
import '../../repository/message_repository.dart';
import '../../repository/person_repository.dart';
import '../../service/auth_service.dart';
import '../../service/connectivity_service.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final String _chatId;
  final AuthService _authService;
  final ChatRepository _chatRepository;
  final MessageRepository _messageRepository;
  final PersonRepository _personRepository;
  final DateService _dateService;
  final ConnectivityService _connectivityService;
  StreamSubscription<List<Message>>? _messagesListener;

  ChatCubit({
    required String chatId,
    ChatState initialState = const ChatState(status: BlocStatusInitial()),
  })  : _chatId = chatId,
        _authService = getIt<AuthService>(),
        _chatRepository = getIt<ChatRepository>(),
        _messageRepository = getIt<MessageRepository>(),
        _personRepository = getIt<PersonRepository>(),
        _dateService = getIt<DateService>(),
        _connectivityService = getIt<ConnectivityService>(),
        super(initialState);

  @override
  Future<void> close() {
    _messagesListener?.cancel();
    _messagesListener = null;
    return super.close();
  }

  Future<void> initialize() async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) return;
    final Chat chat =
        await _chatRepository.getChatById(chatId: _chatId).whereNotNull().first;
    final Person recipient = await _personRepository
        .getPersonById(
          personId: chat.user1Id == loggedUserId ? chat.user2Id : chat.user1Id,
        )
        .whereNotNull()
        .first;
    _messagesListener ??=
        _messageRepository.getMessagesForChat(chatId: _chatId).listen(
      (List<Message> messages) {
        final List<Message> sortedMessages = [...messages];
        sortedMessages.sort(
          (m1, m2) => m1.dateTime.isBefore(m2.dateTime) ? 1 : -1,
        );
        emit(state.copyWith(
          loggedUserId: loggedUserId,
          recipientFullName: '${recipient.name} ${recipient.surname}',
          messagesFromLatest: sortedMessages,
        ));
      },
    );
  }

  void messageChanged(String message) async {
    emit(state.copyWith(
      messageToSend: message,
    ));
  }

  Future<void> submitMessage() async {
    if (!state.canSubmitMessage) return;
    if (await _connectivityService.hasDeviceInternetConnection()) {
      final DateTime now = _dateService.getNow();
      emit(state.copyWith(status: const BlocStatusLoading()));
      await _messageRepository.addMessageToChat(
        chatId: _chatId,
        senderId: state.loggedUserId!,
        content: state.messageToSend!,
        dateTime: now,
      );
      emit(state.copyWith(
        status: const BlocStatusComplete(),
        messageToSendAsNull: true,
      ));
    } else {
      emit(state.copyWith(
        status: const BlocStatusError<ChatCubitError>(
          error: ChatCubitError.noInternetConnection,
        ),
      ));
    }
  }

  Future<void> loadOlderMessages() async {
    final List<Message>? messages = state.messagesFromLatest;
    if (messages == null || messages.isEmpty) return;
    final String lastVisibleMessageId = messages.last.id;
    await _messageRepository.loadOlderMessagesForChat(
      chatId: _chatId,
      lastVisibleMessageId: lastVisibleMessageId,
    );
  }
}

enum ChatCubitError { noInternetConnection }
