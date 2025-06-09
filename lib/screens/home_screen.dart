import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/post_model.dart';
import '../models/company_model.dart';
import '../data/posts.dart';
import '../data/companies.dart';
import '../widgets/post_carousel.dart';
import '../widgets/company_card.dart';
import '../screens/all_companies_screen.dart';
import '../screens/all_posts_screen.dart';
import '../screens/all_trends_screen.dart';
import 'dart:ui';
import '../services/trends_service.dart';
import '../models/trend_model.dart';
import '../screens/add_post_screen.dart';
import '../screens/post_detail_screen.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  final Function() toggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    Key? key,
    required this.toggleTheme,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TrendsService _trendsService = TrendsService();
  List<Trend> _aiTrends = [];
  bool _isLoading = true;
  String? _error;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Post> _filteredPosts = List.from(dummyPosts);
  List<Trend> _filteredTrends = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadAITrends();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadAITrends() async {
    try {
      final trends = await _trendsService.getTechTrends();
      setState(() {
        _aiTrends = trends;
        _filteredTrends = trends;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = _searchController.text;
        _filterPosts();
        _filterTrends();
      });
    });
  }

  void _filterPosts() {
    setState(() {
      if (_searchQuery.isEmpty) {
        _filteredPosts = List.from(dummyPosts);
      } else {
        _filteredPosts = dummyPosts.where((post) {
          return post.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              post.content.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();
      }
    });
  }

  void _filterTrends() {
    setState(() {
      if (_searchQuery.isEmpty) {
        _filteredTrends = List.from(_aiTrends);
      } else {
        _filteredTrends = _aiTrends.where((trend) {
          return trend.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              trend.description.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();
      }
    });
  }

  void _addPost() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const AddPostScreen(),
      ),
    );
  }

  void _deletePost(String id) {
    setState(() {
      dummyPosts.removeWhere((post) => post.id == id);
      _filteredPosts.removeWhere((post) => post.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isWeb = kIsWeb;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            stretch: true,
            expandedHeight: 120,
            backgroundColor: Colors.transparent,
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: colorScheme.surface.withOpacity(0.8),
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                Text(
                  'Startup Hub',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: colorScheme.primary,
                ),
                onPressed: widget.toggleTheme,
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search posts, trends, and more...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Featured Posts
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Featured Posts',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllPostsScreen(posts: _filteredPosts),
                          ),
                        );
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: PostCarousel(
                    posts: _filteredPosts,
                    onPostTap: (post) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailScreen(post: post),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
                // AI Trends
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'AI Trends',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_error != null)
                  Center(
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredTrends.length,
                    itemBuilder: (context, index) {
                      final trend = _filteredTrends[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          title: Text(trend.title),
                          subtitle: Text(trend.description),
                          trailing: Chip(
                            label: Text(trend.category),
                            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                          ),
                          onTap: () async {
                            if (trend.url.isNotEmpty) {
                              final uri = Uri.parse(trend.url);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              }
                            }
                          },
                        ),
                      );
                    },
                  ),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPost,
        child: const Icon(Icons.add),
      ),
    );
  }
} 