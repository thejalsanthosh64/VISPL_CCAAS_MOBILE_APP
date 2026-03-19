class DispositionSummaryResponse {
  final List<DispositionItem> items;

  const DispositionSummaryResponse({
    required this.items,
  });

  factory DispositionSummaryResponse.fromJson(dynamic json) {
    final List list = json is List ? json : (json['data'] as List? ?? []);

    // We no longer split by comma! We take the exact grouped string the backend gives us.
    final parsedItems = list.map((e) {
      final rawName = e['disposition_form_name']?.toString().trim() ?? '';
      final count = int.tryParse(e['count'].toString()) ?? 0;

      final finalName = rawName.isEmpty ? 'Unknown' : rawName;

      return DispositionItem(name: finalName, count: count);
    }).toList();

    return DispositionSummaryResponse(items: parsedItems);
  }
}

class DispositionItem {
  final String name;
  final int count;

  DispositionItem({
    required this.name,
    required this.count,
  });

  factory DispositionItem.fromJson(Map<String, dynamic> json) {
    final rawName = json['disposition_form_name']?.toString().trim() ?? '';
    return DispositionItem(
      name: rawName.isEmpty ? 'Unknown' : rawName,
      count: int.tryParse(json['count'].toString()) ?? 0,
    );
  }
}