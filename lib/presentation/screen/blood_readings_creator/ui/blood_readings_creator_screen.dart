import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../../../domain/model/blood_parameter.dart';
import '../../../component/text/label_text_components.dart';
import '../../../component/text/title_text_components.dart';
import '../../../formatter/blood_test_parameter_formatter.dart';
import '../../../formatter/blood_test_parameter_norm_formatter.dart';
import '../../../formatter/blood_test_parameter_unit_formatter.dart';

part 'blood_readings_creator_content.dart';
part 'blood_readings_creator_parameters.dart';

class BloodReadingsCreatorScreen extends StatelessWidget {
  const BloodReadingsCreatorScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _Content();
  }
}
