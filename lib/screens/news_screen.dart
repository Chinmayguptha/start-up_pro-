import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/news_service.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final NewsService _newsService = NewsService();
  List<NewsArticle> _startupNews = [];
  List<NewsArticle> _techNews = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadNews();
  }

  Future<void> _loadNews() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final startupNews = await _newsService.getStartupNews();
      final techNews = await _newsService.getTechNews();

      setState(() {
        _startupNews = startupNews;
        _techNews = techNews;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Startup News'),
            Tab(text: 'Tech News'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadNews,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildNewsList(_startupNews),
                    _buildNewsList(_techNews),
                  ],
                ),
    );
  }

  Widget _buildNewsList(List<NewsArticle> articles) {
    return RefreshIndicator(
      onRefresh: _loadNews,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return Card(
            elevation: 2,
            child: InkWell(
              onTap: () async {
                if (article.url != null) {
                  final url = Uri.parse(article.url!);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Could not open the article'),
                        ),
                      );
                    }
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        child: Image.network(
                          article.urlToImage!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                        ),
                      ),
                    const SizedBox(height: 12),
                    Text(
                      article.title ?? 'No title available',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (article.description != null && article.description!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        article.description!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (article.source.isNotEmpty) ...[
                          Text(
                            article.source,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
} 