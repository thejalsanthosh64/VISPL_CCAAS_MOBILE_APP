class DispositionSummaryResponse {
  final List<DispositionItem> items;

  const DispositionSummaryResponse({
    required this.items,
  });

  factory DispositionSummaryResponse.fromJson(dynamic json) {
    final Map<String, int> aggregated = {};

    final List list =
        json is List ? json : (json['data'] as List? ?? []);

    for (final e in list) {
      final rawName = e['disposition_form_name']?.toString().trim();
      final count = int.tryParse(e['count'].toString()) ?? 0;

      // Split by comma if multiple names exist
      final names = (rawName == null || rawName.isEmpty)
          ? ['Unknown']
          : rawName.split(',');

      for (var name in names) {
        final key = name.trim().isEmpty ? 'Unknown' : name.trim();
        aggregated[key] = (aggregated[key] ?? 0) + count;
      }
    }

    return DispositionSummaryResponse(
      items: aggregated.entries
          .map((e) => DispositionItem(name: e.key, count: e.value))
          .toList(),
    );
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
    return DispositionItem(
      name: (json['disposition_form_name']?.toString().isNotEmpty ?? false)
          ? json['disposition_form_name']
          : 'Unknown',
      count: int.tryParse(json['count'].toString()) ?? 0,
    );
  }
}
