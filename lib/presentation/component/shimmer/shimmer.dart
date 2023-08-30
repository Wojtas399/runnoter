import 'package:flutter/widgets.dart';

class Shimmer extends StatefulWidget {
  final bool isDarkMode;

  static ShimmerState? of(BuildContext context) {
    return context.findAncestorStateOfType<ShimmerState>();
  }

  const Shimmer({
    super.key,
    this.isDarkMode = false,
    this.child,
  });

  final Widget? child;

  @override
  ShimmerState createState() => ShimmerState();
}

class ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late LinearGradient _shimmerGradient;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    _updateShimmerGradient();
    _shimmerController = AnimationController.unbounded(vsync: this)
      ..repeat(
        min: -2,
        max: 2,
        period: const Duration(milliseconds: 1200),
      );
  }

  @override
  void didUpdateWidget(covariant Shimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateShimmerGradient();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }

  Gradient get gradient => LinearGradient(
        colors: _shimmerGradient.colors,
        stops: _shimmerGradient.stops,
        begin: _shimmerGradient.begin,
        end: _shimmerGradient.end,
        transform: _SlidingGradientTransform(
          slidePercent: _shimmerController.value,
        ),
      );

  bool get isSized =>
      (context.findRenderObject() as RenderBox?)?.hasSize ?? false;

  Size get size =>
      (context.findRenderObject() as RenderBox?)?.size ?? Size.zero;

  Listenable get shimmerChanges => _shimmerController;

  Offset getDescendantOffset({
    required RenderBox descendant,
    Offset offset = Offset.zero,
  }) {
    final shimmerBox = context.findRenderObject() as RenderBox;
    return descendant.localToGlobal(offset, ancestor: shimmerBox);
  }

  void _updateShimmerGradient() {
    setState(() {
      _shimmerGradient = LinearGradient(
        colors: [
          widget.isDarkMode ? const Color(0xFF666666) : const Color(0xFFD4D4D4),
          widget.isDarkMode ? const Color(0xFF868686) : const Color(0xFFF4F4F4),
          widget.isDarkMode ? const Color(0xFF666666) : const Color(0xFFD4D4D4),
        ],
        stops: const [
          0.1,
          0.3,
          0.4,
        ],
        begin: const Alignment(-1.0, -0.3),
        end: const Alignment(1.0, 0.3),
        tileMode: TileMode.clamp,
      );
    });
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({
    required this.slidePercent,
  });

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}
