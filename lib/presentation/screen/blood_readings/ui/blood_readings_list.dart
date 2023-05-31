part of 'blood_readings_screen.dart';

class _BloodReadingsList extends StatelessWidget {
  const _BloodReadingsList();

  @override
  Widget build(BuildContext context) {
    final List<BloodReadingsFromYear>? bloodReadingsByYear = context.select(
      (BloodReadingsCubit cubit) => cubit.state,
    );

    if (bloodReadingsByYear == null) {
      return const _LoadingContent();
    } else if (bloodReadingsByYear.isEmpty) {
      return const _EmptyListContent();
    } else {
      return Column(
        children: bloodReadingsByYear
            .asMap()
            .entries
            .map(
              (entry) => entry.key == bloodReadingsByYear.length - 1
                  ? _ReadingsFromYear(readingsFromYear: entry.value)
                  : Column(
                      children: [
                        _ReadingsFromYear(readingsFromYear: entry.value),
                        const Divider(),
                      ],
                    ),
            )
            .toList(),
      );
    }
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _EmptyListContent extends StatelessWidget {
  const _EmptyListContent();

  @override
  Widget build(BuildContext context) {
    return EmptyContentInfo(
      icon: Icons.water_drop_outlined,
      title: Str.of(context).bloodReadingsNoReadingsTitle,
      subtitle: Str.of(context).bloodReadingsNoReadingsMessage,
    );
  }
}

class _ReadingsFromYear extends StatelessWidget {
  final BloodReadingsFromYear readingsFromYear;

  const _ReadingsFromYear({
    required this.readingsFromYear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleLarge(
            readingsFromYear.year.toString(),
          ),
          const SizedBox(height: 16),
          ...readingsFromYear.bloodReadings.map(
            (BloodReading reading) => _ReadingItem(
              bloodReading: reading,
              onPressed: () {
                _onPressed(context, reading.id);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onPressed(BuildContext context, String bloodReadingId) {
    navigateTo(
      context: context,
      route: BloodReadingPreviewRoute(
        bloodReadingId: bloodReadingId,
      ),
    );
  }
}

class _ReadingItem extends StatelessWidget {
  final BloodReading bloodReading;
  final VoidCallback? onPressed;

  const _ReadingItem({
    required this.bloodReading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 16),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            bloodReading.date.toDateWithDots(),
          ),
        ),
      ),
    );
  }
}
