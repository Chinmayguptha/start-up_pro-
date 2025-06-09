class Post {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String imageUrl;
  final DateTime createdAt;
  final List<String> tags;
  final String author;
  final String category;

  Post({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.imageUrl,
    required this.createdAt,
    required this.tags,
    required this.author,
    required this.category,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      title: json['title'] as String,
      excerpt: json['excerpt'] as String,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      tags: List<String>.from(json['tags'] as List),
      author: json['author'] as String,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'excerpt': excerpt,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'tags': tags,
      'author': author,
      'category': category,
    };
  }

  Post copyWith({
    String? id,
    String? title,
    String? excerpt,
    String? content,
    String? imageUrl,
    DateTime? createdAt,
    List<String>? tags,
    String? author,
    String? category,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      excerpt: excerpt ?? this.excerpt,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
      author: author ?? this.author,
      category: category ?? this.category,
    );
  }
} 