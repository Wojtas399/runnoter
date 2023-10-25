import 'dart:math';

import 'package:flutter/material.dart';

import '../../component/gap/gap_horizontal_components.dart';
import 'chat_message_card.dart';

class ChatTypingIndicator extends StatefulWidget {
  final bool showIndicator;

  const ChatTypingIndicator({super.key, this.showIndicator = false});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ChatTypingIndicator> with TickerProviderStateMixin {
  late final AnimationController _bodyAnimController;
  late final AnimationController _repeatingAnimController;
  late final Animation<double> _sizeAnimation;
  late final Animation<double> _scaleAnimation;
  final List<Interval> _dotIntervals = const [
    Interval(0.10, 0.8),
    Interval(0.20, 0.9),
    Interval(0.30, 1.0),
  ];

  @override
  void initState() {
    super.initState();
    _bodyAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _repeatingAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _sizeAnimation = CurvedAnimation(
      parent: _bodyAnimController,
      curve: Curves.easeInOutQuart,
    );
    _scaleAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _bodyAnimController,
        curve: Curves.easeInOutQuart,
      ),
    );
    if (widget.showIndicator) _showIndicator();
  }

  @override
  void didUpdateWidget(ChatTypingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showIndicator != oldWidget.showIndicator) {
      if (widget.showIndicator) {
        _showIndicator();
      } else {
        _hideIndicator();
      }
    }
  }

  @override
  void dispose() {
    _bodyAnimController.dispose();
    _repeatingAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizeTransition(
          sizeFactor: _sizeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ChatMessageCard(
                hasMessageBeenSentByLoggedUser: false,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _StatusBubble(
                    repeatingAnimController: _repeatingAnimController,
                    dotIntervals: _dotIntervals,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showIndicator() {
    _bodyAnimController.forward();
    _repeatingAnimController.repeat();
  }

  void _hideIndicator() {
    _repeatingAnimController.stop();
    _bodyAnimController.reverse();
  }
}

class _StatusBubble extends StatelessWidget {
  final AnimationController repeatingAnimController;
  final List<Interval> dotIntervals;

  const _StatusBubble({
    required this.repeatingAnimController,
    required this.dotIntervals,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _AnimatedCircle(
          index: 0,
          repeatingAnimController: repeatingAnimController,
          dotIntervals: dotIntervals,
        ),
        const GapHorizontal8(),
        _AnimatedCircle(
          index: 1,
          repeatingAnimController: repeatingAnimController,
          dotIntervals: dotIntervals,
        ),
        const GapHorizontal8(),
        _AnimatedCircle(
          index: 2,
          repeatingAnimController: repeatingAnimController,
          dotIntervals: dotIntervals,
        ),
      ],
    );
  }
}

class _AnimatedCircle extends StatelessWidget {
  final int index;
  final AnimationController repeatingAnimController;
  final List<Interval> dotIntervals;

  const _AnimatedCircle({
    required this.index,
    required this.repeatingAnimController,
    required this.dotIntervals,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: repeatingAnimController,
      builder: (context, child) {
        final double animationPercent = dotIntervals[index].transform(
          repeatingAnimController.value,
        );
        final double colorPercent = sin(pi * animationPercent);
        const jumpAnimCubic = Cubic(0.68, -0.3, 0.265, 1.3);
        const double jumpHeight = 8.0;
        final jumpAnimVal =
            jumpHeight * sin(pi * jumpAnimCubic.transform(animationPercent));

        return Transform.translate(
          offset: Offset(0, -jumpAnimVal),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.lerp(
                Theme.of(context).colorScheme.outlineVariant,
                Theme.of(context).colorScheme.outline,
                colorPercent,
              ),
            ),
          ),
        );
      },
    );
  }
}
