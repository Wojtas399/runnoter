part of 'blood_reading_creator_screen.dart';

class _AllParameters extends StatelessWidget {
  const _AllParameters();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: _Parameters.build(
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
          sliver: _Parameters.build(
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

class _Parameters extends SliverStickyHeader {
  _Parameters({
    super.header,
    super.sliver,
  });

  factory _Parameters.build({
    required BuildContext context,
    required String label,
    required List<BloodParameter> parameters,
  }) {
    return _Parameters(
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
            const _Header(),
          ],
        ),
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => Table(
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
                  (parameter) => _Parameter.build(parameter, context),
                )
                .toList(),
          ),
          childCount: 1,
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

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

class _Parameter extends TableRow {
  const _Parameter({
    super.children,
  });

  factory _Parameter.build(
    BloodParameter parameter,
    BuildContext context,
  ) {
    return _Parameter(
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
        const TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Wynik',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
