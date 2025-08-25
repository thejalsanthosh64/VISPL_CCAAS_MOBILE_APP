enum CallDirectionEnum {
  incoming(value: "INCOMING"),
  outgoing(value: "OUTGOING");

  const CallDirectionEnum({required this.value});

  final String value;
}
