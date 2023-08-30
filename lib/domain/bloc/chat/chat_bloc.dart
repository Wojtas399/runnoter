import 'package:flutter_bloc/flutter_bloc.dart';

import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/bloc_with_status.dart';
import '../../entity/message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends BlocWithStatus<ChatEvent, ChatState, dynamic, dynamic> {
  ChatBloc({
    ChatState initialState = const ChatState(status: BlocStatusInitial()),
  }) : super(initialState) {
    on<ChatEventInitialize>(_initialize);
  }

  void _initialize(
    ChatEventInitialize event,
    Emitter<ChatState> emit,
  ) {
    //TODO
  }
}
