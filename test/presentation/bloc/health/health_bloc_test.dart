void main() {
  // final dateService = MockDateService();
  // final authService = MockAuthService();
  // final morningMeasurementRepository = MockMorningMeasurementRepository();
  //
  // HealthBloc createBloc() => HealthBloc(
  //       dateService: dateService,
  //       authService: authService,
  //       morningMeasurementRepository: morningMeasurementRepository,
  //     );
  //
  // HealthState createState({
  //   BlocStatus status = const BlocStatusInitial(),
  //   MorningMeasurement? thisMorningMeasurement,
  //   ChartRange chartRange = ChartRange.week,
  //   List<MorningMeasurement>? morningMeasurements,
  //   List<HealthChartPoint>? chartPoints,
  // }) =>
  //     HealthState(
  //       status: status,
  //       thisMorningMeasurement: thisMorningMeasurement,
  //       chartRange: chartRange,
  //       morningMeasurements: morningMeasurements,
  //       chartPoints: chartPoints,
  //     );
  //
  // tearDown(() {
  //   reset(dateService);
  //   reset(authService);
  //   reset(morningMeasurementRepository);
  // });
  //
  // blocTest(
  //   'initialize, '
  //   "should set listener of logged user's this morning measurement and measurements from current week",
  //   build: () => createBloc(),
  //   setUp: () {
  //     dateService.mockGetToday(
  //       todayDate: DateTime(2023, 1, 10),
  //     );
  //     dateService.mockGetFirstDateFromWeekMatchingToDate(
  //       date: DateTime(2023, 1, 8),
  //     );
  //     dateService.mockGetLastDateFromWeekMatchingToDate(
  //       date: DateTime(2023, 1, 14),
  //     );
  //     authService.mockGetLoggedUserId(
  //       userId: 'u1',
  //     );
  //     morningMeasurementRepository.mockGetMeasurementByDate(
  //       measurement: createMorningMeasurement(
  //         date: DateTime(2023, 1, 10),
  //       ),
  //     );
  //     morningMeasurementRepository.mockGetMeasurementsByDateRange(
  //       measurements: [
  //         createMorningMeasurement(
  //           date: DateTime(2023, 1, 10),
  //         ),
  //         createMorningMeasurement(
  //           date: DateTime(2023, 1, 11),
  //         ),
  //         createMorningMeasurement(
  //           date: DateTime(2023, 1, 8),
  //         ),
  //       ],
  //     );
  //   },
  //   act: (HealthBloc bloc) => bloc.add(
  //     const HealthEventInitialize(),
  //   ),
  //   expect: () => [
  //     createState(
  //       status: const BlocStatusComplete(),
  //       thisMorningMeasurement: createMorningMeasurement(
  //         date: DateTime(2023, 1, 10),
  //       ),
  //       morningMeasurements: [
  //         createMorningMeasurement(
  //           date: DateTime(2023, 1, 10),
  //         ),
  //         createMorningMeasurement(
  //           date: DateTime(2023, 1, 11),
  //         ),
  //         createMorningMeasurement(
  //           date: DateTime(2023, 1, 8),
  //         ),
  //       ],
  //     ),
  //   ],
  //   verify: (_) {
  //     verify(
  //       () => authService.loggedUserId$,
  //     ).called(1);
  //     verify(
  //       () => morningMeasurementRepository.getMeasurementByDate(
  //         date: DateTime(2023, 1, 10),
  //         userId: 'u1',
  //       ),
  //     ).called(1);
  //     verify(
  //       () => morningMeasurementRepository.getMeasurementsByDateRange(
  //         startDate: DateTime(2023, 1, 8),
  //         endDate: DateTime(2023, 1, 14),
  //         userId: 'u1',
  //       ),
  //     ).called(1);
  //   },
  // );
  //
  // blocTest(
  //   'listened params updated, '
  //   'should update this morning measurement and morning measurements in state',
  //   build: () => createBloc(),
  //   act: (HealthBloc bloc) => bloc.add(
  //     HealthEventListenedParamsUpdated(
  //       updatedListenedParams: HealthStateListenedParams(
  //         thisMorningMeasurement: createMorningMeasurement(
  //           date: DateTime(2023, 1, 10),
  //         ),
  //         morningMeasurements: [
  //           createMorningMeasurement(
  //             date: DateTime(2023, 1, 10),
  //           ),
  //           createMorningMeasurement(
  //             date: DateTime(2023, 1, 11),
  //           ),
  //         ],
  //       ),
  //     ),
  //   ),
  //   expect: () => [
  //     createState(
  //       status: const BlocStatusComplete(),
  //       thisMorningMeasurement: createMorningMeasurement(
  //         date: DateTime(2023, 1, 10),
  //       ),
  //       morningMeasurements: [
  //         createMorningMeasurement(
  //           date: DateTime(2023, 1, 10),
  //         ),
  //         createMorningMeasurement(
  //           date: DateTime(2023, 1, 11),
  //         ),
  //       ],
  //     ),
  //   ],
  // );
  //
  // blocTest(
  //   'add morning measurement, '
  //   'logged user does not exist, '
  //   'should do nothing',
  //   build: () => createBloc(),
  //   setUp: () => authService.mockGetLoggedUserId(),
  //   act: (HealthBloc bloc) => bloc.add(
  //     const HealthEventAddMorningMeasurement(
  //       restingHeartRate: 50,
  //       fastingWeight: 80.2,
  //     ),
  //   ),
  //   expect: () => [],
  //   verify: (_) => verify(
  //     () => authService.loggedUserId$,
  //   ).called(1),
  // );
  //
  // blocTest(
  //   'add morning measurement, '
  //   'logged user exists, '
  //   "should call morning measurement repository's method to add new morning measurement with today date and should emit info that morning measurement has been added",
  //   build: () => createBloc(),
  //   setUp: () {
  //     authService.mockGetLoggedUserId(userId: 'u1');
  //     dateService.mockGetToday(
  //       todayDate: DateTime(2023, 1, 10),
  //     );
  //     morningMeasurementRepository.mockAddMeasurement();
  //   },
  //   act: (HealthBloc bloc) => bloc.add(
  //     const HealthEventAddMorningMeasurement(
  //       restingHeartRate: 50,
  //       fastingWeight: 80.2,
  //     ),
  //   ),
  //   expect: () => [
  //     createState(
  //       status: const BlocStatusLoading(),
  //     ),
  //     createState(
  //       status: const BlocStatusComplete<HealthBlocInfo>(
  //         info: HealthBlocInfo.morningMeasurementAdded,
  //       ),
  //     ),
  //   ],
  //   verify: (_) {
  //     verify(
  //       () => authService.loggedUserId$,
  //     ).called(1);
  //     verify(
  //       () => morningMeasurementRepository.addMeasurement(
  //         userId: 'u1',
  //         measurement: MorningMeasurement(
  //           date: DateTime(2023, 1, 10),
  //           restingHeartRate: 50,
  //           fastingWeight: 80.2,
  //         ),
  //       ),
  //     ).called(1);
  //   },
  // );
  //
  // blocTest(
  //   'change chart range, '
  //   'should update chart range in state',
  //   build: () => createBloc(),
  //   act: (HealthBloc bloc) => bloc.add(
  //     const HealthEventChangeChartRange(
  //       newChartRange: ChartRange.month,
  //     ),
  //   ),
  //   expect: () => [
  //     createState(
  //       status: const BlocStatusComplete(),
  //       chartRange: ChartRange.month,
  //     ),
  //   ],
  // );
}
