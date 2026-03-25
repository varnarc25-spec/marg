class TrendItem {
  final String title;
  final String contentType;

  const TrendItem({
    required this.title,
    required this.contentType,
  });

  factory TrendItem.fromJson(Map<String, dynamic> json) {
    return TrendItem(
      title: json['title']?.toString() ?? '',
      contentType: json['contentType']?.toString() ?? '',
    );
  }
}

