import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/cubit/chat/chat_cubit.dart';
import '../../component/body/big_body_component.dart';
import '../../component/nullable_text_component.dart';
import 'chat_bottom_part.dart';
import 'chat_messages.dart';

class ChatContent extends StatelessWidget {
  const ChatContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).canvasColor,
        centerTitle: true,
        title: const _RecipientFullName(),
      ),
      body: const SafeArea(
        child: BigBody(
          child: kIsWeb ? _ScrollRefresherContent() : _DragRefresherContent(),
        ),
      ),
    );
  }
}

class _RecipientFullName extends StatelessWidget {
  const _RecipientFullName();

  @override
  Widget build(BuildContext context) {
    final String? recipientFullName = context.select(
      (ChatCubit cubit) => cubit.state.recipientFullName,
    );

    return NullableText(recipientFullName);
  }
}

class _DragRefresherContent extends StatelessWidget {
  const _DragRefresherContent();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async =>
          await context.read<ChatCubit>().loadOlderMessages(),
      child: Column(
        children: [
          Expanded(
            child: ChatMessages(),
          ),
          ChatBottomPart(),
        ],
      ),
    );
  }
}

class _ScrollRefresherContent extends StatefulWidget {
  const _ScrollRefresherContent();

  @override
  State<StatefulWidget> createState() => _ScrollRefresherContentState();
}

class _ScrollRefresherContentState extends State<_ScrollRefresherContent> {
  StreamSubscription<int>? _numberOfMessagesListener;
  final ScrollController _scrollController = ScrollController();
  int _numberOfMessages = 0;
  bool _isLoading = false;
  bool _isEndOfList = false;

  @override
  void initState() {
    _numberOfMessagesListener ??= context
        .read<ChatCubit>()
        .stream
        .map((ChatState chatState) => chatState.messagesFromLatest?.length)
        .whereNotNull()
        .listen(
          (int newNumberOfMessages) => setState(() {
            _isEndOfList = _numberOfMessages == newNumberOfMessages;
            _numberOfMessages = newNumberOfMessages;
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
        Column(
          children: [
            Expanded(
              child: ChatMessages(scrollController: _scrollController),
            ),
            ChatBottomPart(),
          ],
        ),
        _WebRefreshIndicator(isLoading: _isLoading),
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
        scrollPosition.extentAfter < 100) {
      setState(() {
        _isLoading = true;
      });
      await context.read<ChatCubit>().loadOlderMessages();
      setState(() {
        _isLoading = false;
      });
    }
  }
}

class _WebRefreshIndicator extends StatefulWidget {
  final bool isLoading;

  const _WebRefreshIndicator({required this.isLoading});

  @override
  State<StatefulWidget> createState() => _WebRefreshIndicatorState();
}

class _WebRefreshIndicatorState extends State<_WebRefreshIndicator> {
  double yPosition = -50;

  @override
  void didUpdateWidget(covariant _WebRefreshIndicator oldWidget) {
    setState(() {
      yPosition = widget.isLoading ? 25 : -50;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: yPosition,
      left: 0,
      right: 0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            child: Container(
              padding: const EdgeInsets.all(8),
              width: 40,
              height: 40,
              child: const CircularProgressIndicator(strokeWidth: 3),
            ),
          ),
        ],
      ),
    );
  }
}
