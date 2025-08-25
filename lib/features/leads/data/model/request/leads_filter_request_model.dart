import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kommuno/features/leads/data/enum/lead_filter_enum.dart';

part 'leads_filter_request_model.g.dart';

@HiveType(typeId: 1)
class LeadsFilterRequestModel extends Equatable {
  const LeadsFilterRequestModel({
    required this.leadFilterEnum,
    required this.val,
  });

  @HiveField(0)
  final LeadFilterEnum leadFilterEnum;
  @HiveField(1)
  final String val;

  LeadsFilterRequestModel copyWith({
    LeadFilterEnum? leadFilterEnum,
    String? val,
  }) {
    return LeadsFilterRequestModel(
      leadFilterEnum: leadFilterEnum ?? this.leadFilterEnum,
      val: val ?? this.val,
    );
  }

  Map<String, dynamic> toJson() => {
        "name": leadFilterEnum.name,
        "val": val,
        "op": leadFilterEnum.op,
      };

  @override
  String toString() {
    return "$leadFilterEnum, $val, ";
  }

  @override
  List<Object?> get props => [leadFilterEnum, val];
}
