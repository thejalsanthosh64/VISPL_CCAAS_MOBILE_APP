import 'package:equatable/equatable.dart';
import 'package:kommuno/features/recent_calls/data/enum/recent_calls_filter_enum.dart';

// class RecentCallsRequestModel extends Equatable {
//   const RecentCallsRequestModel({
//     required this.recentCallsFilterEnum,
//     required this.val,
//   });

//   final RecentCallsFilterEnum recentCallsFilterEnum;

//   final String val;

//   RecentCallsRequestModel copyWith({
//     RecentCallsFilterEnum? recentCallsFilterEnum,
//     String? val,
//   }) {
//     return RecentCallsRequestModel(
//       recentCallsFilterEnum:
//           recentCallsFilterEnum ?? this.recentCallsFilterEnum,
//       val: val ?? this.val,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "name": recentCallsFilterEnum.name,
//         "val": val,
//       };

//   @override
//   String toString() {
//     return "$recentCallsFilterEnum, $val, ";
//   }

//   @override
//   List<Object?> get props => [recentCallsFilterEnum, val];
// }

// class RecentCallsRequestModel extends Equatable {
//   const RecentCallsRequestModel({
//     required this.agentNumber,
//     required this.startDateTime,
//     required this.endDateTime,
//     required this.batchSize,
//     required this.initialRecord,
//   });

//   final String agentNumber;
//   final String startDateTime;  
//   final String endDateTime;    
//   final int batchSize;
//   final int initialRecord;

//   Map<String, dynamic> toJson() => {
//         "agent_number": agentNumber,
//         "start_date_time": startDateTime,
//         "end_date_time": endDateTime,
//         "batchSize": batchSize,
//         "initialRecord": initialRecord,
//       };

//   @override
//   List<Object?> get props => [agentNumber, startDateTime, endDateTime, batchSize, initialRecord];
// }

class RecentCallsRequestModel extends Equatable {
  const RecentCallsRequestModel({
    required this.agentId,
    required this.startDate,
    required this.endDate,
    required this.batchSize,
    required this.initialRecord,
  });

  final int agentId;
  final String startDate;   
  final String endDate;     
  final int batchSize;
  final int initialRecord;

  Map<String, dynamic> toJson() => {
        "filterList": {
          "startDate": startDate,
          "endDate": endDate,
          "agent_id": agentId,
        },
        "batchSize": batchSize,
        "initialRecord": initialRecord,
        "agentId": agentId,
      };

  @override
  List<Object?> get props =>
      [agentId, startDate, endDate, batchSize, initialRecord];
}
