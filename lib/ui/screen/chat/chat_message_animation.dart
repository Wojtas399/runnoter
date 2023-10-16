import 'package:flutter/material.dart';

class ChatMessageAnimation extends StatefulWidget {
  final bool shouldRunAnimation;
  final bool hasMessageBeenSentByLoggedUser;
  final Widget child;

  const ChatMessageAnimation({
    super.key,
    required this.shouldRunAnimation,
    required this.hasMessageBeenSentByLoggedUser,
    required this.child,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ChatMessageAnimation>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final AnimationController _animationController;
  late final Animation<double> _sizeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
    _sizeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutQuart,
    );
    _scaleAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutQuart,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return widget.shouldRunAnimation
        ? SizeTransition(
            sizeFactor: _sizeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              alignment: widget.hasMessageBeenSentByLoggedUser
                  ? Alignment.bottomRight
                  : Alignment.bottomLeft,
              child: widget.child,
            ),
          )
        : widget.child;
  }
}
