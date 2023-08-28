import 'package:flutter/widgets.dart';

import 'shimmer.dart';

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> {
  Listenable? _shimmerChanges;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_shimmerChanges != null) {
      _shimmerChanges!.removeListener(_onShimmerChange);
    }
    _shimmerChanges = Shimmer.of(context)?.shimmerChanges;
    if (_shimmerChanges != null) {
      _shimmerChanges!.addListener(_onShimmerChange);
    }
  }

  @override
  void dispose() {
    _shimmerChanges?.removeListener(_onShimmerChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shimmer = Shimmer.of(context)!;
    if (!shimmer.isSized) {
      return const SizedBox();
    }
    final shimmerSize = shimmer.size;
    final gradient = shimmer.gradient;
    final renderObject = context.findRenderObject() as RenderBox?;
    Offset? offsetWithinShimmer;
    if (renderObject != null) {
      offsetWithinShimmer = shimmer.getDescendantOffset(
        descendant: renderObject,
      );
    }

    return offsetWithinShimmer != null
        ? ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) {
              return gradient.createShader(
                Rect.fromLTWH(
                  -offsetWithinShimmer!.dx,
                  -offsetWithinShimmer.dy,
                  shimmerSize.width,
                  shimmerSize.height,
                ),
              );
            },
            child: widget.child,
          )
        : widget.child;
  }

  void _onShimmerChange() {
    setState(() {});
  }
}
