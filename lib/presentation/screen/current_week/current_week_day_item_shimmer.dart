import 'package:flutter/material.dart';

import '../../component/gap/gap_components.dart';
import '../../component/shimmer/shimmer_container.dart';

class CurrentWeekDayItemShimmer extends StatelessWidget {
  const CurrentWeekDayItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerContainer(height: 24, width: 150),
          Gap16(),
          _HealthDataShimmer(),
          Gap16(),
          ShimmerContainer(height: 48, width: double.infinity),
        ],
      ),
    );
  }
}

class _HealthDataShimmer extends StatelessWidget {
  const _HealthDataShimmer();

  @override
  Widget build(BuildContext context) {
    return const IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                ShimmerContainer(height: 14, width: 130),
                Gap8(),
                ShimmerContainer(height: 16, width: 70),
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: Column(
              children: [
                ShimmerContainer(height: 14, width: 130),
                Gap8(),
                ShimmerContainer(height: 16, width: 70),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
