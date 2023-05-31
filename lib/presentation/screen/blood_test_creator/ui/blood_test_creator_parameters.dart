part of 'blood_test_creator_screen.dart';

class _AllParameters extends StatelessWidget {
  const _AllParameters();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: _SectionParameters.build(
            context: context,
            label: 'Badania podstawowe',
            parameters: BloodParameter.values
                .where(
                  (param) => param.type == BloodParameterType.basic,
                )
                .toList(),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: _SectionParameters.build(
            context: context,
            label: 'Badania dodatkowe',
            parameters: BloodParameter.values
                .where(
                  (param) => param.type == BloodParameterType.additional,
                )
                .toList(),
          ),
        ),
      ],
    );
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
    required List<BloodParameter> parameters,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 16,
                ),
                child: TitleMedium(label),
              ),
              const _TableHeaderRow(),
            ],
          ),
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) => _ParamsTable(
              parameters: parameters,
            ),
            childCount: 1,
          ),
        ),
      );
}

class _TableHeaderRow extends StatelessWidget {
  const _TableHeaderRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: LabelLarge(
            'Nazwa',
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: LabelLarge(
            'Norma',
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: LabelLarge(
            'Wynik',
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _ParamsTable extends StatelessWidget {
  final List<BloodParameter> parameters;

  const _ParamsTable({
    required this.parameters,
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
      children: parameters
          .map(
            (parameter) => _ParameterRow.build(
              context: context,
              parameter: parameter,
              onValueChanged: (double? value) {
                _onValueChanged(context, parameter, value);
              },
            ),
          )
          .toList(),
    );
  }

  void _onValueChanged(
    BuildContext context,
    BloodParameter parameter,
    double? value,
  ) {
    context.read<BloodTestCreatorBloc>().add(
          BloodTestCreatorEventParameterResultChanged(
            parameter: parameter,
            value: value,
          ),
        );
  }
}

class _ParameterRow extends TableRow {
  const _ParameterRow({
    super.children,
  });

  _ParameterRow.build({
    required BuildContext context,
    required BloodParameter parameter,
    required Function(double? value) onValueChanged,
  }) : this(
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  parameter.toName(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${parameter.norm.toUIFormat()} ${parameter.unit.toUIFormat()}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TextFieldComponent(
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  inputFormatters: [
                    DecimalTextInputFormatter(decimalRange: 2),
                  ],
                  textAlign: TextAlign.center,
                  onChanged: (String? valueStr) {
                    if (valueStr != null) {
                      onValueChanged(
                        double.tryParse(valueStr),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        );
}
