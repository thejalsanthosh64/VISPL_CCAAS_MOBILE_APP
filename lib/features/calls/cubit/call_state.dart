class CallState {
  final bool isConnected;
  final bool isMuted;
  final bool isHold;
  final Duration duration;
  final String callerName;
  final String phoneNumber;



  const CallState({
    this.isConnected = false,
    this.isMuted = false,
    this.isHold = false,
    this.duration = Duration.zero,
    this.callerName = "",
    this.phoneNumber = "",
  });

  CallState copyWith({
    bool? isConnected,
    bool? isMuted,
    bool? isHold,
    Duration? duration,
    String? callerName,
    String? phoneNumber,
  }) {
    return CallState(
      isConnected: isConnected ?? this.isConnected,
      isMuted: isMuted ?? this.isMuted,
      isHold: isHold ?? this.isHold,
      duration: duration ?? this.duration,
      callerName: callerName ?? this.callerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

    @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CallState &&
        other.isConnected == isConnected &&
        other.isMuted == isMuted &&
        other.isHold == isHold &&
        other.callerName == callerName &&
        other.phoneNumber == phoneNumber && 
        other.duration == duration;
  }

  @override
  int get hashCode {
    return isConnected.hashCode ^
        isMuted.hashCode ^
        isHold.hashCode ^
        callerName.hashCode ^
        phoneNumber.hashCode ^ 
        duration.hashCode;
  }
}
