import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/company_model.dart';
import '../models/funding_model.dart';
import '../data/companies.dart';
import '../data/fundings.dart';
import '../screens/company_detail_screen.dart';
import '../screens/add_company_screen.dart';
import 'dart:ui';

class FundingScreen extends StatefulWidget {
  const FundingScreen({Key? key}) : super(key: key);

  @override
  State<FundingScreen> createState() => _FundingScreenState();
}

class _FundingScreenState extends State<FundingScreen> {
  List<CompanyModel> _companies = [];
  List<FundingModel> _fundings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Simulate loading data
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _companies = dummyCompanies;
      _fundings = dummyFundings;
      _isLoading = false;
    });
  }

  void _deleteCompany(CompanyModel company) {
    setState(() {
      _companies.removeWhere((c) => c.id == company.id);
      _fundings.removeWhere((f) => f.companyId == company.id);
    });
  }

  Future<void> _addNewCompany() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddCompanyScreen(),
      ),
    );

    if (result != null && result is CompanyModel) {
      setState(() {
        _companies.add(result);
        if (result.fundingRounds.isNotEmpty) {
          _fundings.addAll(result.fundingRounds);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isWeb = kIsWeb;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
              title: const Text('Funding Tracker'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addNewCompany,
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final company = _companies[index];
                    final companyFundings = _fundings
                        .where((f) => f.companyId == company.id)
                        .toList();
                    final totalFunding = companyFundings
                        .fold(0.0, (sum, funding) => sum + funding.amount);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: colorScheme.primary.withOpacity(0.1),
                          child: Text(
                            company.name[0],
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(company.name),
                        subtitle: Text(
                          'Total Funding: \$${totalFunding.toStringAsFixed(1)}M',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteCompany(company),
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CompanyDetailScreen(
                                      company: company,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _companies.length,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewCompany,
        child: const Icon(Icons.add),
      ),
    );
  }
} 