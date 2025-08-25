import 'package:equatable/equatable.dart';

class BreakResponseModel extends Equatable {
  const BreakResponseModel({
    this.breaks = const [],
    this.schAssignedCount,
    this.schFollowUpCount,
    this.signIn,
    this.signInStr,
    this.signOut,
    this.signOutStr,
    this.status,
    this.totalActiveTime,
    this.totalActiveTimeStr,
    this.totalBreakTime,
    this.totalBreakTimeStr,
    this.breakStatus,
  });

  final List<BreaksListModel> breaks;
  final int? schAssignedCount;
  final int? schFollowUpCount;
  final int? signIn;
  final String? signInStr;
  final int? signOut;
  final String? signOutStr;
  final int? status;
  final int? breakStatus;
  final int? totalActiveTime;
  final String? totalActiveTimeStr;
  final int? totalBreakTime;
  final String? totalBreakTimeStr;

  BreakResponseModel copyWith({
    List<BreaksListModel>? breaks,
    int? schAssignedCount,
    int? schFollowUpCount,
    int? signIn,
    String? signInStr,
    int? signOut,
    String? signOutStr,
    int? status,
    int? breakStatus,
    int? totalActiveTime,
    String? totalActiveTimeStr,
    int? totalBreakTime,
    String? totalBreakTimeStr,
  }) {
    return BreakResponseModel(
      breaks: breaks ?? this.breaks,
      schAssignedCount: schAssignedCount ?? this.schAssignedCount,
      schFollowUpCount: schFollowUpCount ?? this.schFollowUpCount,
      signIn: signIn ?? this.signIn,
      signInStr: signInStr ?? this.signInStr,
      signOut: signOut ?? this.signOut,
      signOutStr: signOutStr ?? this.signOutStr,
      status: status ?? this.status,
      breakStatus: breakStatus ?? this.breakStatus,
      totalActiveTime: totalActiveTime ?? this.totalActiveTime,
      totalActiveTimeStr: totalActiveTimeStr ?? this.totalActiveTimeStr,
      totalBreakTime: totalBreakTime ?? this.totalBreakTime,
      totalBreakTimeStr: totalBreakTimeStr ?? this.totalBreakTimeStr,
    );
  }

  factory BreakResponseModel.fromJson(Map<String, dynamic> json) {
    return BreakResponseModel(
      breaks: json["breaks"] == null
          ? []
          : List<BreaksListModel>.from(
              json["breaks"]!.map((x) => BreaksListModel.fromJson(x))),
      schAssignedCount: json["schAssinedCount"],
      schFollowUpCount: json["schFollowUpCount"],
      signIn: json["signIn"],
      signInStr: json["signInStr"],
      signOut: json["signOut"],
      signOutStr: json["signOutStr"],
      status: json["status"],
      breakStatus: json["break_status"],
      totalActiveTime: json["totalActiveTime"],
      totalActiveTimeStr: json["totalActiveTimeStr"],
      totalBreakTime: json["totalBreakTime"],
      totalBreakTimeStr: json["totalBreakTimeStr"],
    );
  }

  Map<String, dynamic> toJson() => {
        "breaks": breaks.map((x) => x.toJson()).toList(),
        "schAssinedCount": schAssignedCount,
        "schFollowUpCount": schFollowUpCount,
        "signIn": signIn,
        "signInStr": signInStr,
        "signOut": signOut,
        "signOutStr": signOutStr,
        "status": status,
        "totalActiveTime": totalActiveTime,
        "totalActiveTimeStr": totalActiveTimeStr,
        "totalBreakTime": totalBreakTime,
        "totalBreakTimeStr": totalBreakTimeStr,
        "break_status": breakStatus,
      };

  @override
  String toString() {
    return "$breaks, $schAssignedCount, $schFollowUpCount, $signIn, $signInStr, $signOut, $signOutStr, $status, $breakStatus, $totalActiveTime, $totalActiveTimeStr, $totalBreakTime, $totalBreakTimeStr, ";
  }

  @override
  List<Object?> get props => [
        breaks,
        schAssignedCount,
        schFollowUpCount,
        signIn,
        signInStr,
        signOut,
        signOutStr,
        status,
        breakStatus,
        totalActiveTime,
        totalActiveTimeStr,
        totalBreakTime,
        totalBreakTimeStr,
      ];
}

class BreaksListModel extends Equatable {
  const BreaksListModel({
    this.breakOutStr,
    this.breakOut,
    this.breakInStr,
    this.breakIn,
  });

  final String? breakOutStr;
  final int? breakOut;
  final String? breakInStr;
  final int? breakIn;

  BreaksListModel copyWith({
    String? breakOutStr,
    int? breakOut,
    String? breakInStr,
    int? breakIn,
  }) {
    return BreaksListModel(
      breakOutStr: breakOutStr ?? this.breakOutStr,
      breakOut: breakOut ?? this.breakOut,
      breakInStr: breakInStr ?? this.breakInStr,
      breakIn: breakIn ?? this.breakIn,
    );
  }

  factory BreaksListModel.fromJson(Map<String, dynamic> json) {
    return BreaksListModel(
      breakOutStr: json["breakOutStr"],
      breakOut: json["breakOut"],
      breakInStr: json["breakInStr"],
      breakIn: json["breakIn"],
    );
  }

  Map<String, dynamic> toJson() => {
        "breakOutStr": breakOutStr,
        "breakOut": breakOut,
        "breakInStr": breakInStr,
        "breakIn": breakIn,
      };

  @override
  String toString() {
    return "$breakOutStr, $breakOut, $breakInStr, $breakIn, ";
  }

  @override
  List<Object?> get props => [
        breakOutStr,
        breakOut,
        breakInStr,
        breakIn,
      ];
}
