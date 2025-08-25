enum RecentCallsFilterEnum {
  startDate(name: "startDate"),
  endDate(name: "endDate");

  const RecentCallsFilterEnum({required this.name});

  final String name;
}
