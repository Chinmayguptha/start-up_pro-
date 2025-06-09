import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import '../models/company_model.dart';
import '../models/funding_model.dart';
import 'dart:ui';

class CompanyDetailScreen extends StatelessWidget {
  final CompanyModel company;

  const CompanyDetailScreen({
    Key? key,
    required this.company,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isWeb = kIsWeb;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share(
                'Check out ${company.name}!\n\n'
                'Domain: ${company.domain}\n'
                'Founder: ${company.founder}\n'
                'Location: ${company.location}\n'
                'Founded: ${company.yearFounded}\n'
                'Stage: ${company.stage}\n\n'
                'Description: ${company.description}',
              );
            },
          ),
        ],
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                ),
                child: Center(
                  child: Text(
                    company.name[0],
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.name,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      company.domain,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildInfoSection(
                      context,
                      'Company Information',
                      [
                        _buildInfoRow('Founder', company.founder),
                        _buildInfoRow('Location', company.location),
                        _buildInfoRow('Year Founded', company.yearFounded.toString()),
                        _buildInfoRow('Stage', company.stage),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildInfoSection(
                      context,
                      'Description',
                      [
                        Text(
                          company.description,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    if (company.fundingRounds.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildInfoSection(
                        context,
                        'Funding History',
                        company.fundingRounds.map((round) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\$${round.amount}M',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${round.round} - ${round.date}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              if (round.leadInvestor != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Lead Investor: ${round.leadInvestor}',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
} 