import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../data/companies.dart';
import '../widgets/company_card.dart';
import 'dart:ui';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredCompanies = dummyCompanies;
  String _selectedStage = 'All';

  List<String> get _stages => ['All', 'Seed', 'Series A', 'Series B', 'Series C'];

  void _filterCompanies(String query) {
    setState(() {
      _filteredCompanies = dummyCompanies.where((company) {
        final matchesSearch = company.name.toLowerCase().contains(query.toLowerCase()) ||
            company.domain.toLowerCase().contains(query.toLowerCase()) ||
            company.description.toLowerCase().contains(query.toLowerCase());
        final matchesStage = _selectedStage == 'All' || company.stage == _selectedStage;
        return matchesSearch && matchesStage;
      }).toList();
    });
  }

  void _onStageChanged(String? stage) {
    if (stage != null) {
      setState(() {
        _selectedStage = stage;
        _filterCompanies(_searchController.text);
      });
    }
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
              title: const Text('Search Companies'),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(120),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 48,
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search companies...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: colorScheme.surface,
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          onChanged: _filterCompanies,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 40,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _stages.map((stage) {
                              final isSelected = stage == _selectedStage;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(stage),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    if (selected) {
                                      _onStageChanged(stage);
                                    }
                                  },
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 320 / 450,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= _filteredCompanies.length) {
                      return null;
                    }
                    return CompanyCard(
                      company: _filteredCompanies[index],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 