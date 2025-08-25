import 'package:equatable/equatable.dart';
import 'package:kommuno/features/recent_calls/data/enum/recent_calls_filter_enum.dart';

class RecentCallsRequestModel extends Equatable {
  const RecentCallsRequestModel({
    required this.recentCallsFilterEnum,
    required this.val,
  });

  final RecentCallsFilterEnum recentCallsFilterEnum;

  final String val;

  RecentCallsRequestModel copyWith({
    RecentCallsFilterEnum? recentCallsFilterEnum,
    String? val,
  }) {
    return RecentCallsRequestModel(
      recentCallsFilterEnum:
          recentCallsFilterEnum ?? this.recentCallsFilterEnum,
      val: val ?? this.val,
    );
  }

  Map<String, dynamic> toJson() => {
        "name": recentCallsFilterEnum.name,
        "val": val,
      };

  @override
  String toString() {
    return "$recentCallsFilterEnum, $val, ";
  }

  @override
  List<Object?> get props => [recentCallsFilterEnum, val];
}
