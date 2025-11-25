import 'package:equatable/equatable.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/core/common/app_keys.dart';

class LeadFilterPriceSortOrderData extends Equatable {
  final int id;

  final String text;

  const LeadFilterPriceSortOrderData({required this.text, required this.id});

  static final priceOrderItems = <LeadFilterPriceSortOrderData>[
    LeadFilterPriceSortOrderData(
        text:
            AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!.lessThan,
        id: 0),
    LeadFilterPriceSortOrderData(
        text: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
            .greaterThan,
        id: 1),
    LeadFilterPriceSortOrderData(
        text:
            AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!.equalsTo,
        id: 2),
  ];

  @override
  List<Object?> get props => [id, text];
}
