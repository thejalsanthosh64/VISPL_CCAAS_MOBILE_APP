import 'package:equatable/equatable.dart';

class LeadsFilterDateSortOrderData extends Equatable {
  final int id;

  final String value;

  const LeadsFilterDateSortOrderData({required this.value, required this.id});

  static final leadsFilterDateSortOrderData = <LeadsFilterDateSortOrderData>[
    const LeadsFilterDateSortOrderData(
        value: "ucd.update_date_time Desc", id: 1),
    const LeadsFilterDateSortOrderData(
        value: "ucd.insert_date_time Desc", id: 2),
  ];

  @override
  List<Object?> get props => [id, value];
}
