import 'package:flutter/material.dart';

import '../gap/gap_components.dart';
import 'shimmer_container.dart';

class WeekDayItemShimmer extends StatelessWidget {
  const WeekDayItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerContainer(height: 24, width: 150),
          Gap8(),
          ShimmerContainer(height: 48, width: double.infinity),
        ],
      ),
    );
  }
}
