import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../services/trends_service.dart';
import '../models/trend_model.dart';

class AllTrendsScreen extends StatefulWidget {
  const AllTrendsScreen({Key? key}) : super(key: key);

  @override
  State<AllTrendsScreen> createState() => _AllTrendsScreenState();
}

class _AllTrendsScreenState extends State<AllTrendsScreen> {
  final TrendsService _trendsService = TrendsService();
  List<Map<String, dynamic>> trends = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchTrends();
  }

  void _fetchTrends() async {
    try {
      final fetchedTrends = await _trendsService.getTechTrends();
      setState(() {
        trends = fetchedTrends.map((trend) => trend.toJson()).toList();
      });
    } catch (e) {
      print('Error fetching trends: $e');
    }
  }

  List<Map<String, dynamic>> get _filteredTrends {
    if (_searchQuery.isEmpty) return trends;
    return trends.where((trend) {
      final title = trend['title'].toString().toLowerCase();
      final description = trend['description'].toString().toLowerCase();
      final category = trend['category'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return title.contains(query) || 
             description.contains(query) || 
             category.contains(query);
    }).toList();
  }

  void _showAddTrendDialog() {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final marketSizeController = TextEditingController();
    final growthRateController = TextEditingController();
    final keyPlayersController = TextEditingController();
    final useCasesController = TextEditingController();
    IconData selectedIcon = Icons.auto_awesome;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New AI Trend'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Trend Title',
                    hintText: 'e.g., AI in Agriculture',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Brief description of the trend',
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: marketSizeController,
                  decoration: const InputDecoration(
                    labelText: 'Market Size',
                    hintText: 'e.g., \$10.5B',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter market size';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: growthRateController,
                  decoration: const InputDecoration(
                    labelText: 'Growth Rate',
                    hintText: 'e.g., 35.2%',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter growth rate';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: keyPlayersController,
                  decoration: const InputDecoration(
                    labelText: 'Key Players (comma-separated)',
                    hintText: 'e.g., Company A, Company B, Company C',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter key players';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: useCasesController,
                  decoration: const InputDecoration(
                    labelText: 'Use Cases (comma-separated)',
                    hintText: 'e.g., Use Case 1, Use Case 2, Use Case 3',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter use cases';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<IconData>(
                  value: selectedIcon,
                  decoration: const InputDecoration(
                    labelText: 'Select Icon',
                  ),
                  items: [
                    Icons.auto_awesome,
                    Icons.computer,
                    Icons.devices,
                    Icons.health_and_safety,
                    Icons.school,
                    Icons.factory,
                    Icons.attach_money,
                    Icons.smart_toy,
                    Icons.visibility,
                    Icons.chat,
                  ].map((IconData icon) {
                    return DropdownMenuItem<IconData>(
                      value: icon,
                      child: Icon(icon),
                    );
                  }).toList(),
                  onChanged: (IconData? newValue) {
                    if (newValue != null) {
                      selectedIcon = newValue;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                setState(() {
                  trends.add({
                    'title': titleController.text,
                    'description': descriptionController.text,
                    'icon': selectedIcon,
                    'category': 'Custom',
                    'marketSize': marketSizeController.text,
                    'growthRate': growthRateController.text,
                    'keyPlayers': keyPlayersController.text.split(',').map((e) => e.trim()).toList(),
                    'useCases': useCasesController.text.split(',').map((e) => e.trim()).toList(),
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('New trend added successfully!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('Add Trend'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isWeb = kIsWeb;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTrendDialog,
        child: const Icon(Icons.add),
      ),
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
              title: const Text('Top AI Trends'),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(80),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search trends...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isWeb ? 2 : 1,
                  childAspectRatio: isWeb ? 1.2 : 1.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final trend = _filteredTrends[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              colorScheme.primary.withOpacity(0.1),
                              colorScheme.secondary.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    trend['icon'] as IconData,
                                    color: colorScheme.primary,
                                    size: 32,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      trend['title'] as String,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                trend['description'] as String,
                                style: TextStyle(
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _buildInfoChip(
                                    context,
                                    'Market: ${trend['marketSize']}',
                                    colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  _buildInfoChip(
                                    context,
                                    'Growth: ${trend['growthRate']}',
                                    colorScheme.secondary,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Key Players:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: (trend['keyPlayers'] as List<String>).map((player) {
                                  return _buildInfoChip(
                                    context,
                                    player,
                                    colorScheme.primary.withOpacity(0.8),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Use Cases:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.secondary,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: (trend['useCases'] as List<String>).map((useCase) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: colorScheme.secondary.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: colorScheme.secondary.withOpacity(0.5),
                                      ),
                                    ),
                                    child: Text(
                                      useCase,
                                      style: TextStyle(
                                        color: colorScheme.secondary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: _filteredTrends.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.5),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
} 