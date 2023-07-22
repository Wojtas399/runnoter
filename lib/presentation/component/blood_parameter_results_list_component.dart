import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../domain/entity/blood_parameter.dart';
import '../../domain/entity/user.dart';
import '../formatter/blood_test_parameter_formatter.dart';
import '../formatter/blood_test_parameter_norm_range_formatter.dart';
import '../formatter/blood_test_parameter_unit_formatter.dart';
import '../formatter/decimal_text_input_formatter.dart';
import '../service/blood_parameter_service.dart';
import 'nullable_text_component.dart';
import 'text/label_text_components.dart';
import 'text/title_text_components.dart';
import 'text_field_component.dart';

class BloodParameterResultsList extends StatelessWidget {
  final Gender gender;
  final List<BloodParameterResult>? parameterResults;
  final bool isEditMode;
  final Function(BloodParameter bloodParameter, double? value)?
      onParameterValueChanged;

  const BloodParameterResultsList({
    super.key,
    required this.gender,
    this.parameterResults,
    this.isEditMode = false,
    this.onParameterValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: _SectionParameters.build(
            context: context,
            label: Str.of(context).bloodTestBasicParams,
            gender: gender,
            parametersWithValues: _createBloodParametersWithValuesForType(
              BloodParameterType.basic,
            ),
            isEditMode: isEditMode,
            onParameterValueChanged: onParameterValueChanged,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: _SectionParameters.build(
            context: context,
            label: Str.of(context).bloodTestAdditionalParams,
            gender: gender,
            parametersWithValues: _createBloodParametersWithValuesForType(
              BloodParameterType.additional,
            ),
            isEditMode: isEditMode,
            onParameterValueChanged: onParameterValueChanged,
          ),
        ),
      ],
    );
  }

  List<_BloodParameterWithValue> _createBloodParametersWithValuesForType(
    BloodParameterType type,
  ) {
    return BloodParameter.values
        .where(
          (param) => param.type == type,
        )
        .map(
          (param) => _BloodParameterWithValue(
            bloodParameter: param,
            value: parameterResults
                ?.firstWhereOrNull(
                  (readParam) => readParam.parameter == param,
                )
                ?.value,
          ),
        )
        .toList();
  }
}

class _SectionParameters extends SliverStickyHeader {
  _SectionParameters({
    super.header,
    super.sliver,
  });

  factory _SectionParameters.build({
    required BuildContext context,
    required String label,
    required Gender gender,
    required List<_BloodParameterWithValue> parametersWithValues,
    required bool isEditMode,
    Function(BloodParameter parameter, double? value)? onParameterValueChanged,
  }) =>
      _SectionParameters(
        header: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
              ),
            ),
          ),
          padding: const EdgeInsets.only(bottom: 8),
          child: _Header(
            label: label,
          ),
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) => _ParamsTable(
              gender: gender,
              parametersWithValues: parametersWithValues,
              isEditMode: isEditMode,
              onParameterValueChanged: onParameterValueChanged,
            ),
            childCount: 1,
          ),
        ),
      );
}

class _Header extends StatelessWidget {
  final String label;

  const _Header({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 16,
          ),
          child: TitleMedium(label),
        ),
        const _HeaderRow(),
      ],
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LabelLarge(
            Str.of(context).bloodTestParameterName,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: LabelLarge(
            Str.of(context).bloodTestParameterNorm,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: LabelLarge(
            Str.of(context).bloodTestParameterResult,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _ParamsTable extends StatelessWidget {
  final Gender gender;
  final List<_BloodParameterWithValue> parametersWithValues;
  final bool isEditMode;
  final Function(BloodParameter parameter, double? value)?
      onParameterValueChanged;

  const _ParamsTable({
    required this.gender,
    required this.parametersWithValues,
    required this.isEditMode,
    this.onParameterValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
        ),
        verticalInside: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
        ),
      ),
      children: parametersWithValues
          .map(
            (parameterWithValue) => _ParameterRow.build(
              context: context,
              gender: gender,
              parameterWithValue: parameterWithValue,
              isEditMode: isEditMode,
              onValueChanged: (double? value) {
                if (onParameterValueChanged != null) {
                  onParameterValueChanged!(
                    parameterWithValue.bloodParameter,
                    value,
                  );
                }
              },
            ),
          )
          .toList(),
    );
  }
}

class _ParameterRow extends TableRow {
  const _ParameterRow({
    super.children,
  });

  factory _ParameterRow.build({
    required BuildContext context,
    required Gender gender,
    required _BloodParameterWithValue parameterWithValue,
    required bool isEditMode,
    required Function(double? value) onValueChanged,
  }) {
    final BloodParameter parameter = parameterWithValue.bloodParameter;
    final double? value = parameterWithValue.value;
    return _ParameterRow(
      children: [
        _ParameterNameCell.buildForParameterName(
          parameterName: parameter.toName(context),
        ),
        _NormCell.buildForNorm(
          gender: gender,
          norm: parameter.norm,
          unit: parameter.unit,
        ),
        _ResultCell.buildForValue(
          parameterValue: value,
          isValueWithinNorm: value != null
              ? isParameterValueWithinNorm(
                  gender: gender,
                  parameter: parameter,
                  result: value,
                )
              : true,
          isEditMode: isEditMode,
          onValueChanged: onValueChanged,
        ),
      ],
    );
  }
}

class _ParameterNameCell extends TableCell {
  const _ParameterNameCell({
    required super.child,
  }) : super(
          verticalAlignment: TableCellVerticalAlignment.middle,
        );

  _ParameterNameCell.buildForParameterName({
    required String parameterName,
  }) : this(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              parameterName,
              textAlign: TextAlign.center,
            ),
          ),
        );
}

class _NormCell extends TableCell {
  const _NormCell({
    required super.child,
  }) : super(
          verticalAlignment: TableCellVerticalAlignment.middle,
        );

  factory _NormCell.buildForNorm({
    required Gender gender,
    required BloodParameterNorm norm,
    required BloodParameterUnit unit,
  }) {
    final String normStr = switch (norm) {
      BloodParameterNormGeneral() => norm.range.toUIFormat(),
      BloodParameterNormGenderDependent() => switch (gender) {
          Gender.male => norm.maleRange.toUIFormat(),
          Gender.female => norm.femaleRange.toUIFormat(),
        }
    };
    return _NormCell(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          '$normStr ${unit.toUIFormat()}',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ResultCell extends TableCell {
  const _ResultCell({
    required super.child,
  }) : super(
          verticalAlignment: TableCellVerticalAlignment.middle,
        );

  _ResultCell.buildForValue({
    required double? parameterValue,
    required bool isValueWithinNorm,
    required bool isEditMode,
    double padding = 12,
    Function(double? value)? onValueChanged,
  }) : this(
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: isEditMode
                ? _EditableParameterValue(
                    initialValue: parameterValue,
                    onValueChanged: onValueChanged,
                  )
                : NullableText(
                    parameterValue?.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isValueWithinNorm ? null : Colors.red,
                    ),
                  ),
          ),
        );
}

class _EditableParameterValue extends StatefulWidget {
  final double? initialValue;
  final Function(double? value)? onValueChanged;

  const _EditableParameterValue({
    this.initialValue,
    this.onValueChanged,
  });

  @override
  State<StatefulWidget> createState() => _EditableParameterValueState();
}

class _EditableParameterValueState extends State<_EditableParameterValue> {
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller?.text = widget.initialValue?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      maxLines: 1,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      maxLength: 10,
      contentPadding: const EdgeInsets.all(12),
      inputFormatters: [
        DecimalTextInputFormatter(decimalRange: 2),
      ],
      textAlign: TextAlign.center,
      controller: _controller,
      onChanged: (String? valueStr) {
        if (valueStr != null && widget.onValueChanged != null) {
          widget.onValueChanged!(
            double.tryParse(valueStr),
          );
        }
      },
    );
  }
}

class _BloodParameterWithValue {
  final BloodParameter bloodParameter;
  final double? value;

  const _BloodParameterWithValue({
    required this.bloodParameter,
    required this.value,
  });
}
