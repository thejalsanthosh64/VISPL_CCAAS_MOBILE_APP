import 'package:equatable/equatable.dart';
class InsightsResponse extends Equatable {
  const InsightsResponse({
    this.totalInCalls,
    this.avgCallDuration,
    this.inFailedCalls,
    this.inSuccessCalls,
    this.totalOutCalls,
    this.totalCalls,
    this.totalCallDuration,
    this.outSuccessCalls,
    this.outSuccess,
    this.outFailedCalls,
    this.officeHours,
    this.noAnswer,
    this.lunchHours,
    this.inSuccess,

    //  Agent Status fields
    this.talkTime,
    this.totalConnectedDuration,
    this.totalRingingDuration,
    this.wrapUpTime,
    this.waitingTime,
    this.holdTime,
  });

  final int? totalInCalls;
  final int? avgCallDuration;
  final int? inFailedCalls;
  final int? inSuccessCalls;
  final int? totalOutCalls;
  final int? totalCalls;
  final int? totalCallDuration;
  final int? outSuccessCalls;
  final double? outSuccess;
  final int? outFailedCalls;
  final int? officeHours;
  final int? noAnswer;
  final int? lunchHours;
  final double? inSuccess;

  final int? talkTime;
  final int? totalConnectedDuration;
  final int? totalRingingDuration;
  final int? wrapUpTime;
  final int? waitingTime;
  final int? holdTime;

  InsightsResponse copyWith({
    int? totalInCalls,
    int? avgCallDuration,
    int? inFailedCalls,
    int? inSuccessCalls,
    int? totalOutCalls,
    int? totalCalls,
    int? totalCallDuration,
    int? outSuccessCalls,
    double? outSuccess,
    int? outFailedCalls,
    int? officeHours,
    int? noAnswer,
    int? lunchHours,
    double? inSuccess,

    //  Agent Status fields
    int? talkTime,
    int? totalConnectedDuration,
    int? totalRingingDuration,
    int? wrapUpTime,
    int? waitingTime,
    int? holdTime,
  }) {
    return InsightsResponse(
      totalInCalls: totalInCalls ?? this.totalInCalls,
      avgCallDuration: avgCallDuration ?? this.avgCallDuration,
      inFailedCalls: inFailedCalls ?? this.inFailedCalls,
      inSuccessCalls: inSuccessCalls ?? this.inSuccessCalls,
      totalOutCalls: totalOutCalls ?? this.totalOutCalls,
      totalCalls: totalCalls ?? this.totalCalls,
      totalCallDuration: totalCallDuration ?? this.totalCallDuration,
      outSuccessCalls: outSuccessCalls ?? this.outSuccessCalls,
      outSuccess: outSuccess ?? this.outSuccess,
      outFailedCalls: outFailedCalls ?? this.outFailedCalls,
      officeHours: officeHours ?? this.officeHours,
      noAnswer: noAnswer ?? this.noAnswer,
      lunchHours: lunchHours ?? this.lunchHours,
      inSuccess: inSuccess ?? this.inSuccess,

      talkTime: talkTime ?? this.talkTime,
      totalConnectedDuration:
          totalConnectedDuration ?? this.totalConnectedDuration,
      totalRingingDuration:
          totalRingingDuration ?? this.totalRingingDuration,
      wrapUpTime: wrapUpTime ?? this.wrapUpTime,
      waitingTime: waitingTime ?? this.waitingTime,
      holdTime: holdTime ?? this.holdTime,
    );
  }

  factory InsightsResponse.fromJson(Map<String, dynamic> json) {
    return InsightsResponse(
      totalInCalls: json["totalInCalls"],
      avgCallDuration: json["avgCallDuration"],
      inFailedCalls: json["inFailedCalls"],
      inSuccessCalls: json["inSuccessCalls"],
      totalOutCalls: json["totalOutCalls"],
      totalCalls: json["totalCalls"],
      totalCallDuration: json["totalCallDuration"],
      outSuccessCalls: json["outSuccessCalls"],
      outSuccess: double.tryParse((json["outSuccess"] ?? '').toString()),
      outFailedCalls: json["outFailedCalls"],
      officeHours: json["officeHours"],
      noAnswer: json["noAnswer"],
      lunchHours: json["lunchHours"],
      inSuccess: double.tryParse((json["inSuccess"] ?? '').toString()),

      talkTime: json["talkTime"],
      totalConnectedDuration: json["totalConnectedDuration"],
      totalRingingDuration: json["totalRingingDuration"],
      wrapUpTime: json["wrapUpTime"],
      waitingTime: json["waitingTime"],
      holdTime: json["holdTime"],
    );
  }

  Map<String, dynamic> toJson() => {
        "totalInCalls": totalInCalls,
        "avgCallDuration": avgCallDuration,
        "inFailedCalls": inFailedCalls,
        "inSuccessCalls": inSuccessCalls,
        "totalOutCalls": totalOutCalls,
        "totalCalls": totalCalls,
        "totalCallDuration": totalCallDuration,
        "outSuccessCalls": outSuccessCalls,
        "outSuccess": outSuccess,
        "outFailedCalls": outFailedCalls,
        "officeHours": officeHours,
        "noAnswer": noAnswer,
        "lunchHours": lunchHours,
        "inSuccess": inSuccess,

        "talkTime": talkTime,
        "totalConnectedDuration": totalConnectedDuration,
        "totalRingingDuration": totalRingingDuration,
        "wrapUpTime": wrapUpTime,
        "waitingTime": waitingTime,
        "holdTime": holdTime,
      };

  @override
  String toString() {
    return """
InsightsResponse(
  totalInCalls: $totalInCalls,
  avgCallDuration: $avgCallDuration,
  totalCallDuration: $totalCallDuration,
  talkTime: $talkTime,
  wrapUpTime: $wrapUpTime,
  totalRingingDuration: $totalRingingDuration,
  waitingTime: $waitingTime,
  holdTime: $holdTime,
  lunchHours: $lunchHours
)
""";
  }

  @override
  List<Object?> get props => [
        totalInCalls,
        avgCallDuration,
        inFailedCalls,
        inSuccessCalls,
        totalOutCalls,
        totalCalls,
        totalCallDuration,
        outSuccessCalls,
        outSuccess,
        outFailedCalls,
        officeHours,
        noAnswer,
        lunchHours,
        inSuccess,

        talkTime,
        totalConnectedDuration,
        totalRingingDuration,
        wrapUpTime,
        waitingTime,
        holdTime,
      ];
}
