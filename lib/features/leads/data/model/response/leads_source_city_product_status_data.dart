import 'package:equatable/equatable.dart';

class LeadsSourceCityProductStatusData extends Equatable {
  const LeadsSourceCityProductStatusData({
    required this.leadStatus,
    required this.leadSource,
    required this.cities,
    required this.products,
  });

  final List<LeadStatus> leadStatus;
  final List<LeadSource> leadSource;
  final List<LeadCity> cities;
  final List<LeadProduct> products;

  LeadsSourceCityProductStatusData copyWith({
    List<LeadStatus>? leadStatus,
    List<LeadSource>? leadSource,
    List<LeadCity>? cities,
    List<LeadProduct>? products,
  }) {
    return LeadsSourceCityProductStatusData(
      leadStatus: leadStatus ?? this.leadStatus,
      leadSource: leadSource ?? this.leadSource,
      cities: cities ?? this.cities,
      products: products ?? this.products,
    );
  }

  factory LeadsSourceCityProductStatusData.fromJson(Map<String, dynamic> json) {
    return LeadsSourceCityProductStatusData(
      leadStatus: json["leadStatus"] == null
          ? []
          : List<LeadStatus>.from(
              json["leadStatus"]!.map((x) => LeadStatus.fromJson(x))),
      leadSource: json["leadSource"] == null
          ? []
          : List<LeadSource>.from(
              json["leadSource"]!.map((x) => LeadSource.fromJson(x))),
      cities: json["cities"] == null
          ? []
          : List<LeadCity>.from(
              json["cities"]!.map((x) => LeadCity.fromJson(x))),
      products: json["products"] == null
          ? []
          : List<LeadProduct>.from(
              json["products"]!.map((x) => LeadProduct.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "leadStatus": leadStatus.map((x) => x.toJson()).toList(),
        "leadSource": leadSource.map((x) => x.toJson()).toList(),
        "cities": cities.map((x) => x.toJson()).toList(),
        "products": products.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$leadStatus, $leadSource, $cities, $products, ";
  }

  @override
  List<Object?> get props => [
        leadStatus,
        leadSource,
        cities,
        products,
      ];
}

class LeadCity extends Equatable {
  const LeadCity({
    required this.cityId,
    required this.smeId,
    required this.cityName,
    required this.status,
    required this.dateTime,
  });

  final int cityId;
  final String smeId;
  final String cityName;
  final int status;
  final DateTime dateTime;

  LeadCity copyWith({
    int? cityId,
    String? smeId,
    String? cityName,
    int? status,
    DateTime? dateTime,
  }) {
    return LeadCity(
      cityId: cityId ?? this.cityId,
      smeId: smeId ?? this.smeId,
      cityName: cityName ?? this.cityName,
      status: status ?? this.status,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  factory LeadCity.fromJson(Map<String, dynamic> json) {
    return LeadCity(
      cityId: json["city_id"],
      smeId: json["sme_id"],
      cityName: json["city_name"],
      status: json["status"],
      dateTime: DateTime.parse(json["date_time"]).toLocal(),
    );
  }

  Map<String, dynamic> toJson() => {
        "city_id": cityId,
        "sme_id": smeId,
        "city_name": cityName,
        "status": status,
        "date_time": dateTime.toUtc(),
      };

  @override
  String toString() {
    return "$cityId, $smeId, $cityName, $status, $dateTime, ";
  }

  @override
  List<Object?> get props => [
        cityId,
        smeId,
        cityName,
        status,
        dateTime,
      ];
}

class LeadStatus extends Equatable {
  const LeadStatus({
    required this.id,
    this.source,
    required this.description,
    required this.insertDateTime,
    required this.createdBy,
    required this.leadStatus,
  });

  final int id;
  final String? source;
  final String description;
  final DateTime insertDateTime;
  final int createdBy;
  final String leadStatus;

  LeadStatus copyWith({
    int? id,
    String? source,
    String? description,
    DateTime? insertDateTime,
    int? createdBy,
    String? leadStatus,
  }) {
    return LeadStatus(
      id: id ?? this.id,
      source: source ?? this.source,
      description: description ?? this.description,
      insertDateTime: insertDateTime ?? this.insertDateTime,
      createdBy: createdBy ?? this.createdBy,
      leadStatus: leadStatus ?? this.leadStatus,
    );
  }

  factory LeadStatus.fromJson(Map<String, dynamic> json) {
    return LeadStatus(
      id: json["id"],
      source: json["source"],
      description: json["description"],
      insertDateTime: DateTime.parse(json["insert_date_time"]).toLocal(),
      createdBy: json["created_by"],
      leadStatus: json["leadStatus"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "source": source,
        "description": description,
        "insert_date_time": insertDateTime.toUtc(),
        "created_by": createdBy,
        "leadStatus": leadStatus,
      };

  @override
  String toString() {
    return "$id, $source, $description, $insertDateTime, $createdBy, $leadStatus, ";
  }

  @override
  List<Object?> get props => [
        id,
        source,
        description,
        insertDateTime,
        createdBy,
        leadStatus,
      ];
}

class LeadSource extends Equatable {
  const LeadSource({
    required this.id,
    required this.source,
    required this.description,
    required this.insertDateTime,
    required this.createdBy,
    this.leadStatus,
  });

  final int id;
  final String source;
  final String description;
  final DateTime insertDateTime;
  final int createdBy;
  final String? leadStatus;

  LeadSource copyWith({
    int? id,
    String? source,
    String? description,
    DateTime? insertDateTime,
    int? createdBy,
    String? leadStatus,
  }) {
    return LeadSource(
      id: id ?? this.id,
      source: source ?? this.source,
      description: description ?? this.description,
      insertDateTime: insertDateTime ?? this.insertDateTime,
      createdBy: createdBy ?? this.createdBy,
      leadStatus: leadStatus ?? this.leadStatus,
    );
  }

  factory LeadSource.fromJson(Map<String, dynamic> json) {
    return LeadSource(
      id: json["id"],
      source: json["source"],
      description: json["description"],
      insertDateTime: DateTime.parse(json["insert_date_time"]).toLocal(),
      createdBy: json["created_by"],
      leadStatus: json["leadStatus"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "source": source,
        "description": description,
        "insert_date_time": insertDateTime.toUtc(),
        "created_by": createdBy,
        "leadStatus": leadStatus,
      };

  @override
  String toString() {
    return "$id, $source, $description, $insertDateTime, $createdBy, $leadStatus, ";
  }

  @override
  List<Object?> get props => [
        id,
        source,
        description,
        insertDateTime,
        createdBy,
        leadStatus,
      ];
}

class LeadProduct extends Equatable {
  const LeadProduct({
    required this.id,
    required this.smeId,
    required this.productName,
    required this.status,
    required this.dateTime,
  });

  final int id;
  final String smeId;
  final String? productName;
  final int status;
  final DateTime dateTime;

  LeadProduct copyWith({
    int? id,
    String? smeId,
    String? productName,
    int? status,
    DateTime? dateTime,
  }) {
    return LeadProduct(
      id: id ?? this.id,
      smeId: smeId ?? this.smeId,
      productName: productName ?? this.productName,
      status: status ?? this.status,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  factory LeadProduct.fromJson(Map<String, dynamic> json) {
    return LeadProduct(
      id: json["id"],
      smeId: json["sme_id"],
      productName: json["product_name"],
      status: json["status"],
      dateTime: DateTime.parse(json["date_time"]).toLocal(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "sme_id": smeId,
        "product_name": productName,
        "status": status,
        "date_time": dateTime.toUtc(),
      };

  @override
  String toString() {
    return "$id, $smeId, $productName, $status, $dateTime, ";
  }

  @override
  List<Object?> get props => [
        id,
        smeId,
        productName,
        status,
        dateTime,
      ];
}
