class Trend {
  final String title;
  final String description;
  final String source;
  final String url;
  final String publishedAt;
  final String category;

  Trend({
    required this.title,
    required this.description,
    required this.source,
    required this.url,
    required this.publishedAt,
    required this.category,
  });

  factory Trend.fromJson(Map<String, dynamic> json) => Trend(
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        source: json['source'] ?? '',
        url: json['url'] ?? '',
        publishedAt: json['publishedAt'] ?? '',
        category: json['category'] ?? 'Technology',
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'source': source,
        'url': url,
        'publishedAt': publishedAt,
        'category': category,
      };
} 