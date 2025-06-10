import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/company_model.dart';
import '../models/funding_model.dart';
import '../screens/company_detail_screen.dart';
import 'dart:ui';

class CompanyCard extends StatefulWidget {
  final CompanyModel company;

  const CompanyCard({
    Key? key,
    required this.company,
  }) : super(key: key);

  @override
  State<CompanyCard> createState() => _CompanyCardState();
}

class _CompanyCardState extends State<CompanyCard> {
  int? _selectedFeatureIndex;

  final List<Map<String, dynamic>> _features = [
    {'icon': Icons.person, 'label': 'CEO'},
    {'icon': Icons.group, 'label': 'Team'},
    {'icon': Icons.location_on, 'label': 'Location'},
    {'icon': Icons.contact_phone, 'label': 'Contact'},
    {'icon': Icons.handshake, 'label': 'Partnerships'},
    {'icon': Icons.attach_money, 'label': 'Funding'},
  ];

  void _showFeatureDetails(BuildContext context, int index) {
    final title = _features[index]['label'];
    String content = '';
    
    switch (index) {
      case 0:
        content = widget.company.ceo;
        break;
      case 1:
        content = widget.company.team;
        break;
      case 2:
        content = widget.company.location;
        break;
      case 3:
        content = widget.company.contact;
        break;
      case 4:
        content = widget.company.partnerships;
        break;
      case 5:
        if (widget.company.fundingRounds.isNotEmpty) {
          content = widget.company.fundingRounds.map((round) => 
            '${round.round}: \$${round.amount}M (${round.date})'
          ).join('\n');
        }
        break;
    }

    if (content.isEmpty) {
      content = 'No information available';
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(_features[index]['icon'], size: 24, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(content),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => _showCompanyDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        widget.company.name[0],
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.company.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.company.domain,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 2.5,
                children: List.generate(_features.length, (index) {
                  final feature = _features[index];
                  return InkWell(
                    onTap: () => _showFeatureDetails(context, index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedFeatureIndex == index
                            ? Theme.of(context).primaryColor.withOpacity(0.1)
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _selectedFeatureIndex == index
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).dividerColor,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            feature['icon'],
                            size: 16,
                            color: _selectedFeatureIndex == index
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).iconTheme.color,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            feature['label'],
                            style: TextStyle(
                              fontSize: 12,
                              color: _selectedFeatureIndex == index
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCompanyDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        widget.company.name[0],
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.company.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.company.domain,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailSection('CEO', widget.company.ceo),
              _buildDetailSection('Team', widget.company.team),
              _buildDetailSection('Location', widget.company.location),
              _buildDetailSection('Contact', widget.company.contact),
              _buildDetailSection('Partnerships', widget.company.partnerships),
              if (widget.company.fundingRounds.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Funding History',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...widget.company.fundingRounds.map((round) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        round.round,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '\$${round.amount}M - ${round.date}',
                        style: const TextStyle(fontSize: 13),
                      ),
                      if (round.leadInvestor != null)
                        Text(
                          'Lead Investor: ${round.leadInvestor}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                )).toList(),
              ],
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CompanyDetailScreen(company: widget.company),
                    ));
                  },
                  child: const Text('View Full Details'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    if (content.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}