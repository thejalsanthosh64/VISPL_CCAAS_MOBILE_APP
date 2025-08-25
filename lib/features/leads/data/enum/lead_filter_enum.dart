import 'package:hive/hive.dart';

part 'lead_filter_enum.g.dart';

@HiveType(typeId: 2)
enum LeadFilterEnum {
  @HiveField(0)
  searchLeads(name: "searchLeads", op: 11),
  @HiveField(1)
  startDate(name: "startDate", op: 33),
  @HiveField(2)
  endDate(name: "endDate", op: 34),
  @HiveField(3)
  leadStatus(name: "lead_status", op: 11),
  @HiveField(4)
  leadSource(name: "lead_source", op: 11),
  @HiveField(5)
  cityId(name: "cityId", op: 11),
  @HiveField(6)
  productId(name: "productId", op: 11),
  @HiveField(7)
  productPriceLessThan(name: "product_price", op: 14),
  @HiveField(8)
  productPriceGreaterThan(name: "product_price", op: 13),
  @HiveField(9)
  productPriceEqualTo(name: "product_price", op: 11),
  @HiveField(10)
  communicationDate(name: "sortLeadDateVar", op: 11),
  @HiveField(11)
  createdDate(name: "sortLeadDateVar", op: 11),
  @HiveField(12)
  agentId(name: "agentId", op: 34);

  const LeadFilterEnum({
    required this.name,
    required this.op,
  });

  final String name;
  final int op;
}
