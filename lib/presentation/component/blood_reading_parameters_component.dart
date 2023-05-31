import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../domain/model/blood_parameter.dart';
import '../../domain/model/blood_reading.dart';
import '../formatter/blood_test_parameter_formatter.dart';
import '../formatter/blood_test_parameter_norm_formatter.dart';
import '../formatter/blood_test_parameter_unit_formatter.dart';
import '../formatter/decimal_text_input_formatter.dart';
import 'text/label_text_components.dart';
import 'text/title_text_components.dart';
import 'text_field_component.dart';

class BloodReadingParametersComponent extends StatelessWidget {
  final List<BloodReadingParameter>? readParameters;
  final bool isEditMode;
  final Function(BloodParameter bloodParameter, double? value)?
      onParameterValueChanged;

  const BloodReadingParametersComponent({
    super.key,
    required this.readParameters,
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
            label: Str.of(context).bloodReadingBasicParams,
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
            label: Str.of(context).bloodReadingAdditionalParams,
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
            value: readParameters
                    ?.firstWhereOrNull(
                      (readParam) => readParam.parameter == param,
                    )
                    ?.readingValue ??
                0,
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
            Str.of(context).bloodReadingParameterName,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: LabelLarge(
            Str.of(context).bloodReadingParameterNorm,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: LabelLarge(
            Str.of(context).bloodReadingParameterReading,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _ParamsTable extends StatelessWidget {
  final List<_BloodParameterWithValue> parametersWithValues;
  final bool isEditMode;
  final Function(BloodParameter parameter, double? value)?
      onParameterValueChanged;

  const _ParamsTable({
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
    required _BloodParameterWithValue parameterWithValue,
    required bool isEditMode,
    required Function(double? value) onValueChanged,
  }) {
    final BloodParameter parameter = parameterWithValue.bloodParameter;
    return _ParameterRow(
      children: [
        _ParameterNameCell.buildForParameterName(
          parameterName: parameter.toName(context),
        ),
        _NormCell.buildForNorm(
          norm: parameter.norm,
          unit: parameter.unit,
        ),
        _ResultCell.buildForValue(
          parameterValue: parameterWithValue.value,
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

  _NormCell.buildForNorm({
    required BloodParameterNorm norm,
    required BloodParameterUnit unit,
  }) : this(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              '${norm.toUIFormat()} ${unit.toUIFormat()}',
              textAlign: TextAlign.center,
            ),
          ),
        );
}

class _ResultCell extends TableCell {
  const _ResultCell({
    required super.child,
  }) : super(
          verticalAlignment: TableCellVerticalAlignment.middle,
        );

  _ResultCell.buildForValue({
    required double parameterValue,
    required bool isEditMode,
    double padding = 8,
    Function(double? value)? onValueChanged,
  }) : this(
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: isEditMode
                ? TextFieldComponent(
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    inputFormatters: [
                      DecimalTextInputFormatter(decimalRange: 2),
                    ],
                    textAlign: TextAlign.center,
                    onChanged: (String? valueStr) {
                      if (valueStr != null && onValueChanged != null) {
                        onValueChanged(
                          double.tryParse(valueStr),
                        );
                      }
                    },
                  )
                : Text(
                    parameterValue.toString(),
                    textAlign: TextAlign.center,
                  ),
          ),
        );
}

class _BloodParameterWithValue {
  final BloodParameter bloodParameter;
  final double value;

  const _BloodParameterWithValue({
    required this.bloodParameter,
    required this.value,
  });
}
