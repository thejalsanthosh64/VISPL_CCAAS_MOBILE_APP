import 'package:equatable/equatable.dart';

class ServerContactListModel extends Equatable {
  final String tag;

  final List<ServerContactsResponseModel> contactDisplayDetails;

  const ServerContactListModel({
    required this.tag,
    required this.contactDisplayDetails,
  });

  ServerContactListModel copyWidth({
    String? tag,
    List<ServerContactsResponseModel>? contactDisplayDetails,
  }) {
    return ServerContactListModel(
      tag: tag ?? this.tag,
      contactDisplayDetails:
          contactDisplayDetails ?? this.contactDisplayDetails,
    );
  }

  @override
  List<Object?> get props => [contactDisplayDetails, tag];
}

class ServerContactsResponseModel extends Equatable {
  const ServerContactsResponseModel({
    required this.id,
    required this.smeId,
    required this.customerName,
    required this.customerNumberPrimary,
    required this.mode,
    required this.customerNumberSecondary,
    required this.companyName,
    required this.emailId,
    this.address,
    required this.createdBy,
    required this.visibilityFlag,
    required this.insertDateTime,
    this.updatedDateTime,
    required this.isUpdated,
  });

  final String id;
  final int smeId;
  final String customerName;
  final String customerNumberPrimary;
  final int mode;
  final String customerNumberSecondary;
  final String companyName;
  final String emailId;
  final dynamic address;
  final int createdBy;
  final String visibilityFlag;
  final DateTime insertDateTime;
  final DateTime? updatedDateTime;
  final int isUpdated;

  ServerContactsResponseModel copyWith({
       String? id,

    int? smeId,
    String? customerName,
    String? customerNumberPrimary,
    int? mode,
    String? customerNumberSecondary,
    String? companyName,
    String? emailId,
    dynamic address,
    int? createdBy,
    String? visibilityFlag,
    DateTime? insertDateTime,
    DateTime? updatedDateTime,
    int? isUpdated,
  }) {
    return ServerContactsResponseModel(
      id: id ?? this.id,
      smeId: smeId ?? this.smeId,
      customerName: customerName ?? this.customerName,
      customerNumberPrimary:
          customerNumberPrimary ?? this.customerNumberPrimary,
      mode: mode ?? this.mode,
      customerNumberSecondary:
          customerNumberSecondary ?? this.customerNumberSecondary,
      companyName: companyName ?? this.companyName,
      emailId: emailId ?? this.emailId,
      address: address ?? this.address,
      createdBy: createdBy ?? this.createdBy,
      visibilityFlag: visibilityFlag ?? this.visibilityFlag,
      insertDateTime: insertDateTime ?? this.insertDateTime,
      updatedDateTime: updatedDateTime ?? this.updatedDateTime,
      isUpdated: isUpdated ?? this.isUpdated,
    );
  }

  factory ServerContactsResponseModel.fromJson(Map<String, dynamic> json) {
    return ServerContactsResponseModel(
      id: json["_id"], 
      smeId: json["sme_id"],
      customerName: json["customer_name"] ?? "",
      customerNumberPrimary: json["customer_number_primary"] ?? "",
      mode: json["mode"] ?? 0, 
      customerNumberSecondary: json["customer_number_secondary"]??"",
      companyName: json["company_name"] ?? "",
      emailId: json["email_id"] ?? "",
      address: json["address"]??"",
      createdBy: json["created_by"] ?? 0,
      visibilityFlag: json["visibility_flag"]??"",
      // insertDateTime: DateTime.parse(json["insert_date_time"]),
      // updatedDateTime: json["updated_date_time"] != null
      //     ? DateTime.tryParse(json["updated_date_time"])
      //     : null,

      insertDateTime: _parseCustomDate(json["insert_date_time"]) ?? DateTime.now(),
      
      // updatedDateTime handles null automatically because it is a nullable field.
      updatedDateTime: _parseCustomDate(json["updated_date_time"]),
      isUpdated: json["is_updated"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "sme_id": smeId,
        "customer_name": customerName,
        "customer_number_primary": customerNumberPrimary,
        "MODE": mode,
        "customer_number_secondary": customerNumberSecondary,
        "company_name": companyName,
        "email_id": emailId,
        "address": address,
        "created_by": createdBy,
        "visibility_flag": visibilityFlag,
        "insert_date_time": insertDateTime.toUtc(),
        "updated_date_time": updatedDateTime?.toUtc(),
        "is_updated": isUpdated,
      };

  @override
  String toString() {
    return "$id, $smeId, $customerName, $customerNumberPrimary, $mode, $customerNumberSecondary, $companyName, $emailId, $address, $createdBy, $visibilityFlag, $insertDateTime, $updatedDateTime, $isUpdated, ";
  }

  @override
  List<Object?> get props => [
        id,
        smeId,
        customerName,
        customerNumberPrimary,
        mode,
        customerNumberSecondary,
        companyName,
        emailId,
        address,
        createdBy,
        visibilityFlag,
        insertDateTime,
        updatedDateTime,
        isUpdated,
      ];
}
DateTime? _parseCustomDate(String? dateStr) {
  if (dateStr == null || dateStr.trim().isEmpty) return null;

  try {
    // Attempt 1: Standard format (e.g., "2026-03-25 17:04:44")
    // This will successfully handle 99% of your JSON list
    return DateTime.parse(dateStr);
  } catch (_) {
    // Attempt 2: Handle the verbose format for the user "mm"
    // (e.g., "Fri Apr 25 2025 11:02:49 GMT+0000 (Coordinated Universal Time)")
    try {
      final cleanStr = dateStr.split(' (')[0]; 
      final parts = cleanStr.split(' ');

      if (parts.length >= 6) {
        const months = {
          'Jan': '01', 'Feb': '02', 'Mar': '03', 'Apr': '04', 'May': '05', 'Jun': '06',
          'Jul': '07', 'Aug': '08', 'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12'
        };

        final month = months[parts[1]] ?? '01';
        final day = parts[2].padLeft(2, '0'); 
        final year = parts[3];
        final time = parts[4];
        final offset = parts[5].replaceAll('GMT', ''); 

        // Reconstruct into standard ISO format: "2025-04-25T11:02:49+0000"
        final isoString = '$year-$month-${day}T$time$offset';

        return DateTime.parse(isoString);
      }
    } catch (e) {
      print('Failed to parse custom date: $dateStr');
    }
  }
  return null;
}