import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../component/animated_refresh_indicator.dart';
import '../../cubit/chat/chat_cubit.dart';
import 'chat_messages.dart';

class ChatAdjustableListOfMessages extends StatelessWidget {
  const ChatAdjustableListOfMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? const _ScrollableMessages() : const _DraggableMessages();
  }
}

class _DraggableMessages extends StatelessWidget {
  const _DraggableMessages();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async =>
          await context.read<ChatCubit>().loadOlderMessages(),
      child: const ChatMessages(),
    );
  }
}

class _ScrollableMessages extends StatefulWidget {
  const _ScrollableMessages();

  @override
  State<StatefulWidget> createState() => _ScrollableMessagesState();
}

class _ScrollableMessagesState extends State<_ScrollableMessages> {
  StreamSubscription<int>? _numberOfMessagesListener;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isEndOfList = false;

  @override
  void initState() {
    _numberOfMessagesListener ??= context
        .read<ChatCubit>()
        .stream
        .map((ChatState chatState) => chatState.messagesFromLatest?.length)
        .whereNotNull()
        .distinct()
        .listen(
          (_) => setState(() {
            _isEndOfList = false;
          }),
        );
    _scrollController.addListener(_onScrollPositionChanged);
    super.initState();
  }

  @override
  void dispose() {
    _numberOfMessagesListener?.cancel();
    _numberOfMessagesListener = null;
    _scrollController.removeListener(_onScrollPositionChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ChatMessages(scrollController: _scrollController),
        AnimatedRefreshIndicator(isLoading: _isLoading),
      ],
    );
  }

  Future<void> _onScrollPositionChanged() async {
    final ScrollPosition scrollPosition = _scrollController.position;
    final bool isUpScrolling =
        scrollPosition.userScrollDirection == ScrollDirection.reverse;
    if (!_isEndOfList &&
        !_isLoading &&
        isUpScrolling &&
        scrollPosition.extentAfter < 10) {
      setState(() {
        _isLoading = true;
      });
      await context.read<ChatCubit>().loadOlderMessages();
      setState(() {
        _isEndOfList = true;
        _isLoading = false;
      });
    }
  }
}
