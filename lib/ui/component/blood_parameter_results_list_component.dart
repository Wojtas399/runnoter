import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../data/model/blood_test.dart';
import '../../data/model/user.dart';
import '../formatter/blood_test_parameter_formatter.dart';
import '../formatter/blood_test_parameter_norm_range_formatter.dart';
import '../formatter/blood_test_parameter_unit_formatter.dart';
import '../formatter/decimal_text_input_formatter.dart';
import '../service/blood_parameter_service.dart';
import '../service/utils.dart';
import 'nullable_text_component.dart';
import 'text/label_text_components.dart';
import 'text/title_text_components.dart';

class BloodParameterResultsList extends StatelessWidget {
  final Gender gender;
  final List<BloodParameterResult>? parameterResults;
  final bool isEditMode;
  final Function(BloodParameter bloodParameter, double? value)?
      onParameterValueChanged;
  final VoidCallback? onSubmitted;

  const BloodParameterResultsList({
    super.key,
    required this.gender,
    this.parameterResults,
    this.isEditMode = false,
    this.onParameterValueChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: _SectionParameters.build(
            context: context,
            isFirstSection: true,
            label: Str.of(context).bloodTestBasicParams,
            gender: gender,
            parametersWithValues: _createBloodParametersWithValuesForType(
              BloodParameterType.basic,
            ),
            isEditMode: isEditMode,
            onParameterValueChanged: onParameterValueChanged,
            onSubmitted: onSubmitted,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: _SectionParameters.build(
            context: context,
            isFirstSection: false,
            label: Str.of(context).bloodTestAdditionalParams,
            gender: gender,
            parametersWithValues: _createBloodParametersWithValuesForType(
              BloodParameterType.additional,
            ),
            isEditMode: isEditMode,
            onParameterValueChanged: onParameterValueChanged,
            onSubmitted: onSubmitted,
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
    required bool isFirstSection,
    required String label,
    required Gender gender,
    required List<_BloodParameterWithValue> parametersWithValues,
    required bool isEditMode,
    Function(BloodParameter parameter, double? value)? onParameterValueChanged,
    final VoidCallback? onSubmitted,
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
              isFirstTable: isFirstSection,
              gender: gender,
              parametersWithValues: parametersWithValues,
              isEditMode: isEditMode,
              onParameterValueChanged: onParameterValueChanged,
              onSubmitted: onSubmitted,
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
  final bool isFirstTable;
  final Gender gender;
  final List<_BloodParameterWithValue> parametersWithValues;
  final bool isEditMode;
  final Function(BloodParameter parameter, double? value)?
      onParameterValueChanged;
  final VoidCallback? onSubmitted;

  const _ParamsTable({
    required this.isFirstTable,
    required this.gender,
    required this.parametersWithValues,
    required this.isEditMode,
    this.onParameterValueChanged,
    this.onSubmitted,
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
          .asMap()
          .entries
          .map(
            (entry) => _ParameterRow.build(
              context: context,
              isFirstRow: isFirstTable && entry.key == 0,
              gender: gender,
              parameterWithValue: entry.value,
              isEditMode: isEditMode,
              onValueChanged: (double? value) {
                if (onParameterValueChanged != null) {
                  onParameterValueChanged!(
                    entry.value.bloodParameter,
                    value,
                  );
                }
              },
              onSubmitted: onSubmitted,
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
    required bool isFirstRow,
    required Gender gender,
    required _BloodParameterWithValue parameterWithValue,
    required bool isEditMode,
    required Function(double? value) onValueChanged,
    final VoidCallback? onSubmitted,
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
          isFirstRow: isFirstRow,
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
          onSubmitted: onSubmitted,
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
  }) : super(verticalAlignment: TableCellVerticalAlignment.middle);

  _ResultCell.buildForValue({
    required bool isFirstRow,
    required double? parameterValue,
    required bool isValueWithinNorm,
    required bool isEditMode,
    double padding = 12,
    Function(double? value)? onValueChanged,
    VoidCallback? onSubmitted,
  }) : this(
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: isEditMode
                ? _EditableParameterValue(
                    isFirstRow: isFirstRow,
                    initialValue: parameterValue,
                    onValueChanged: onValueChanged,
                    onSubmitted: onSubmitted,
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
  final bool isFirstRow;
  final double? initialValue;
  final Function(double? value)? onValueChanged;
  final VoidCallback? onSubmitted;

  const _EditableParameterValue({
    required this.isFirstRow,
    this.initialValue,
    this.onValueChanged,
    this.onSubmitted,
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
    return TextField(
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.all(12),
        counterText: '',
      ),
      maxLines: 1,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      maxLength: 10,
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
      onTapOutside: widget.isFirstRow ? (_) => unfocusInputs() : null,
      onSubmitted: (_) =>
          widget.onSubmitted != null ? widget.onSubmitted!() : null,
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
