import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/post_model.dart';
import '../widgets/post_carousel.dart';
import '../screens/add_post_screen.dart';
import 'post_detail_screen.dart';
import 'dart:ui';

class AllPostsScreen extends StatefulWidget {
  final List<Post> posts;

  const AllPostsScreen({
    Key? key,
    required this.posts,
  }) : super(key: key);

  @override
  State<AllPostsScreen> createState() => _AllPostsScreenState();
}

class _AllPostsScreenState extends State<AllPostsScreen> {
  final int _itemsPerPage = 6;
  int _currentPage = 0;
  String _searchQuery = '';

  List<Post> get _filteredPosts {
    return widget.posts.where((post) {
      final matchesSearch = post.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          post.content.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          post.author.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();
  }

  List<Post> get _paginatedPosts {
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return _filteredPosts.sublist(
      startIndex,
      endIndex > _filteredPosts.length ? _filteredPosts.length : endIndex,
    );
  }

  int get _totalPages => (_filteredPosts.length / _itemsPerPage).ceil();

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isWeb = kIsWeb;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withOpacity(0.1),
              colorScheme.surface,
              colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              title: const Text('Latest Insights'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Create Post',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddPostScreen(
                          onPostCreated: (newPost) {
                            setState(() {
                              // The post is already added to dummyPosts in AddPostScreen
                              // Just trigger a rebuild to show the new post
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(80),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search insights...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                        _currentPage = 0;
                      });
                    },
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isWeb ? 2 : 1,
                  childAspectRatio: isWeb ? 1.5 : 1.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= _paginatedPosts.length) {
                      return null;
                    }
                    final post = _paginatedPosts[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostDetailScreen(post: post),
                          ),
                        );
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Image.network(
                                'https://api.allorigins.win/raw?url=${Uri.encodeComponent(post.imageUrl)}',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                    child: const Icon(Icons.image, size: 50),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post.title,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: post.tags.map((tag) => Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '#$tag',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _paginatedPosts.length,
                ),
              ),
            ),
            if (_totalPages > 1)
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 16),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_totalPages, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: IconButton(
                            icon: Icon(
                              Icons.circle,
                              size: 12,
                              color: _currentPage == index
                                  ? colorScheme.primary
                                  : colorScheme.primary.withOpacity(0.3),
                            ),
                            onPressed: () => _onPageChanged(index),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 