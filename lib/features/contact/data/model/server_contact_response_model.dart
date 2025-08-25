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

  final int id;
  final int smeId;
  final String customerName;
  final String customerNumberPrimary;
  final int mode;
  final String customerNumberSecondary;
  final String companyName;
  final String emailId;
  final dynamic address;
  final int createdBy;
  final int visibilityFlag;
  final DateTime insertDateTime;
  final DateTime? updatedDateTime;
  final int isUpdated;

  ServerContactsResponseModel copyWith({
    int? id,
    int? smeId,
    String? customerName,
    String? customerNumberPrimary,
    int? mode,
    String? customerNumberSecondary,
    String? companyName,
    String? emailId,
    dynamic address,
    int? createdBy,
    int? visibilityFlag,
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
      id: json["id"],
      smeId: json["sme_id"],
      customerName: json["customer_name"],
      customerNumberPrimary: json["customer_number_primary"],
      mode: json["MODE"],
      customerNumberSecondary: json["customer_number_secondary"],
      companyName: json["company_name"],
      emailId: json["email_id"],
      address: json["address"],
      createdBy: json["created_by"],
      visibilityFlag: json["visibility_flag"],
      insertDateTime: DateTime.parse(json["insert_date_time"] ?? "").toLocal(),
      updatedDateTime:
          DateTime.tryParse(json["updated_date_time"] ?? "")?.toLocal(),
      isUpdated: json["is_updated"],
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
