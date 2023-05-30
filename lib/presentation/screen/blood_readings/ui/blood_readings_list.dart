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
      return ListView.builder(
        itemCount: bloodReadingsByYear.length,
        itemBuilder: (_, int itemIndex) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: _ReadingsFromYear(
              readingsFromYear: bloodReadingsByYear[itemIndex],
            ),
          );
        },
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
    return const EmptyContentInfo(
      icon: Icons.water_drop_outlined,
      title: 'Brak badań krwi',
      subtitle: 'Dodaj badanie krwi, aby móc przeglądać listę',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleLarge(
          readingsFromYear.year.toString(),
        ),
        const SizedBox(height: 16),
        ...readingsFromYear.bloodReadings.map(
          (BloodReading reading) => _ReadingItem(
            bloodReading: reading,
          ),
        ),
      ],
    );
  }
}

class _ReadingItem extends StatelessWidget {
  final BloodReading bloodReading;

  const _ReadingItem({
    required this.bloodReading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _onPressed(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            bloodReading.date.toDateWithDots(),
          ),
        ),
      ),
    );
  }

  void _onPressed(BuildContext context) {
    //TODO
  }
}
