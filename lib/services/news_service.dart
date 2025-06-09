import 'dart:math';
import '../models/news_article.dart';

class NewsService {
  // Returns a shuffled list of dummy news articles
  Future<List<NewsArticle>> getStartupNews() async {
    return _getDummyNews();
  }

  Future<List<NewsArticle>> getTechNews() async {
    return _getDummyNews();
  }

  List<NewsArticle> _getDummyNews() {
    final now = DateTime.now();
    final List<NewsArticle> articles = [
      NewsArticle(
        title: 'AI Startups Raise Record Funding in Q1 2024',
        description: 'Artificial intelligence startups have secured unprecedented funding in the first quarter of 2024.',
        url: 'https://techcrunch.com',
        urlToImage: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800&auto=format&fit=crop',
        publishedAt: now.subtract(const Duration(hours: 2)).toIso8601String(),
        source: 'TechCrunch',
      ),
      NewsArticle(
        title: 'New Tech Hub Opens in Silicon Valley',
        description: 'A new technology innovation center has opened its doors in the heart of Silicon Valley.',
        url: 'https://theverge.com',
        urlToImage: 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=800&auto=format&fit=crop',
        publishedAt: now.subtract(const Duration(hours: 4)).toIso8601String(),
        source: 'Tech Insider',
      ),
      NewsArticle(
        title: 'Startup Ecosystem Grows in Emerging Markets',
        description: 'Emerging markets are seeing rapid growth in their startup ecosystems.',
        url: 'https://wired.com',
        urlToImage: 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=800&auto=format&fit=crop',
        publishedAt: now.subtract(const Duration(hours: 6)).toIso8601String(),
        source: 'Startup Weekly',
      ),
      NewsArticle(
        title: 'Quantum Computing Breakthrough Announced',
        description: 'Researchers have achieved a major milestone in quantum computing technology.',
        url: 'https://quantamagazine.org',
        urlToImage: 'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=800&auto=format&fit=crop',
        publishedAt: now.subtract(const Duration(days: 1)).toIso8601String(),
        source: 'Quantum Weekly',
      ),
      NewsArticle(
        title: 'Sustainable Tech Solutions on the Rise',
        description: 'Green tech startups are gaining traction with innovative solutions.',
        url: 'https://greentechmedia.com',
        urlToImage: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800&auto=format&fit=crop',
        publishedAt: now.subtract(const Duration(days: 2)).toIso8601String(),
        source: 'Green Tech Review',
      ),
      NewsArticle(
        title: 'Fintech Disruptors Challenge Traditional Banks',
        description: 'Fintech startups are rapidly changing the financial landscape.',
        url: 'https://fintechfutures.com',
        urlToImage: 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=800&auto=format&fit=crop',
        publishedAt: now.subtract(const Duration(days: 3)).toIso8601String(),
        source: 'Fintech News',
      ),
      NewsArticle(
        title: 'HealthTech Innovations Transform Patient Care',
        description: 'New healthtech solutions are improving patient outcomes worldwide.',
        url: 'https://healthtechinsider.com',
        urlToImage: 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?w=800&auto=format&fit=crop',
        publishedAt: now.subtract(const Duration(days: 4)).toIso8601String(),
        source: 'HealthTech Insider',
      ),
      NewsArticle(
        title: 'EdTech Startups Revolutionize Learning',
        description: 'EdTech companies are making education more accessible and engaging.',
        url: 'https://edtechmagazine.com',
        urlToImage: 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?w=800&auto=format&fit=crop',
        publishedAt: now.subtract(const Duration(days: 5)).toIso8601String(),
        source: 'EdTech Magazine',
      ),
      NewsArticle(
        title: 'Robotics in Manufacturing: The Next Wave',
        description: 'Robotics startups are automating manufacturing processes at scale.',
        url: 'https://robohub.org',
        urlToImage: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=800&auto=format&fit=crop',
        publishedAt: now.subtract(const Duration(days: 6)).toIso8601String(),
        source: 'Robotics News',
      ),
      NewsArticle(
        title: 'SpaceTech Startups Eye Mars Missions',
        description: 'Private companies are planning ambitious missions to Mars.',
        url: 'https://spacenews.com',
        urlToImage: 'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=800&auto=format&fit=crop',
        publishedAt: now.subtract(const Duration(days: 7)).toIso8601String(),
        source: 'SpaceTech',
      ),
      NewsArticle(
        title: 'Cybersecurity Startups Defend Against New Threats',
        description: 'Innovative cybersecurity solutions are protecting businesses from evolving threats.',
        url: 'https://securityweek.com',
        urlToImage: 'https://images.unsplash.com/photo-1510511459019-5dda7724fd87?w=800&auto=format&fit=crop',
        publishedAt: now.subtract(const Duration(days: 8)).toIso8601String(),
        source: 'Security Today',
      ),
      NewsArticle(
        title: 'AR/VR Startups Create Immersive Experiences',
        description: 'Augmented and virtual reality companies are changing entertainment and education.',
        url: 'https://arvrtips.com',
        urlToImage: 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800&auto=format&fit=crop',
        publishedAt: now.subtract(const Duration(days: 9)).toIso8601String(),
        source: 'AR/VR News',
      ),
    ];
    // Shuffle the list for dynamic appearance
    articles.shuffle(Random());
    return articles;
  }
}

class NewsArticle {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String source;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.source,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      source: json['source']['name'] ?? '',
    );
  }
} 