import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/company_model.dart';
import '../widgets/company_card.dart';
import '../screens/add_company_screen.dart';
import 'dart:ui';

class AllCompaniesScreen extends StatefulWidget {
  final List<CompanyModel> companies;

  const AllCompaniesScreen({
    Key? key,
    required this.companies,
  }) : super(key: key);

  @override
  State<AllCompaniesScreen> createState() => _AllCompaniesScreenState();
}

class _AllCompaniesScreenState extends State<AllCompaniesScreen> {
  final int _itemsPerPage = 6;
  int _currentPage = 0;
  String _selectedStage = 'All';
  String _searchQuery = '';

  List<String> get _stages => ['All', 'Seed', 'Series A', 'Series B', 'Series C'];

  List<CompanyModel> get _filteredCompanies {
    return widget.companies.where((company) {
      final matchesStage = _selectedStage == 'All' || company.stage == _selectedStage;
      final matchesSearch = company.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          company.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesStage && matchesSearch;
    }).toList();
  }

  List<CompanyModel> get _paginatedCompanies {
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return _filteredCompanies.sublist(
      startIndex,
      endIndex > _filteredCompanies.length ? _filteredCompanies.length : endIndex,
    );
  }

  int get _totalPages => (_filteredCompanies.length / _itemsPerPage).ceil();

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onStageChanged(String? stage) {
    if (stage != null) {
      setState(() {
        _selectedStage = stage;
        _currentPage = 0;
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
              title: const Text('All Companies'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Add Company',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddCompanyScreen(),
                      ),
                    );
                  },
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(120),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
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
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                            _currentPage = 0;
                          });
                        },
                      ),
                      const SizedBox(height: 4),
                      SingleChildScrollView(
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
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isWeb ? 3 : 1,
                  childAspectRatio: isWeb ? 1.5 : 1.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= _paginatedCompanies.length) {
                      return null;
                    }
                    return CompanyCard(
                      company: _paginatedCompanies[index],
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: _currentPage > 0
                          ? () => _onPageChanged(_currentPage - 1)
                          : null,
                    ),
                    Text(
                      'Page ${_currentPage + 1} of $_totalPages',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: _currentPage < _totalPages - 1
                          ? () => _onPageChanged(_currentPage + 1)
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddCompanyScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Company'),
      ),
    );
  }
} 