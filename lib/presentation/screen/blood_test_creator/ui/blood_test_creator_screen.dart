import 'package:flutter/material.dart';

import '../../../../domain/model/blood_test_parameter.dart';
import '../../../formatter/blood_test_parameter_formatter.dart';
import '../../../formatter/blood_test_parameter_unit_formatter.dart';

part 'blood_test_creator_content.dart';

class BloodTestCreatorScreen extends StatelessWidget {
  const BloodTestCreatorScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _Content();
  }
}
