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
  bool _isExpanded = false;
  int? _selectedFeatureIndex;
  Widget? _expandedContent;
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _features = [
    {'icon': Icons.handshake, 'label': 'Partnerships'},
    {'icon': Icons.attach_money, 'label': 'Funding'},
    {'icon': Icons.person, 'label': 'CEO'},
    {'icon': Icons.group, 'label': 'Team'},
    {'icon': Icons.location_on, 'label': 'Location'},
    {'icon': Icons.contact_phone, 'label': 'Contact'},
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onFeatureTap(int index) {
    setState(() {
      _selectedFeatureIndex = index;
      _expandedContent = _buildExpandedContent(index);
      _isExpanded = true;
    });
  }

  Widget _buildExpandedContent(int index) {
    final title = _features[index]['label'];
    final icon = _features[index]['icon'];

    Widget content;
    switch (index) {
      case 0:
        content = Text(
          widget.company.partnerships,
          style: const TextStyle(fontSize: 14),
        );
        break;
      case 1:
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
        );
        break;
      case 2:
        content = Text(
          widget.company.ceo,
          style: const TextStyle(fontSize: 14),
        );
        break;
      case 3:
        content = Text(
          widget.company.team,
          style: const TextStyle(fontSize: 14),
        );
        break;
      case 4:
        content = Text(
          widget.company.location,
          style: const TextStyle(fontSize: 14),
        );
        break;
      case 5:
        content = Text(
          widget.company.contact,
          style: const TextStyle(fontSize: 14),
        );
        break;
      default:
        content = const Text('No information available.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              const SizedBox(height: 8),
              SizedBox(
                height: 110,
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 3.5,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    _buildFeatureItem(Icons.handshake, 'Partnerships', widget.company.partnerships),
                    _buildFeatureItem(Icons.attach_money, 'Funding', widget.company.funding),
                    _buildFeatureItem(Icons.person, 'CEO', widget.company.ceo),
                    _buildFeatureItem(Icons.group, 'Team', widget.company.team),
                    _buildFeatureItem(Icons.location_on, 'Location', widget.company.location),
                    _buildFeatureItem(Icons.contact_phone, 'Contact', widget.company.contact),
                  ],
                ),
              ),
              if (_isExpanded && _expandedContent != null) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: _expandedContent!,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    _isExpanded ? 'View Less' : 'View Details',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String label, String content) {
    String displayContent = content;
    if (label == 'Funding') {
      final totalFunding = widget.company.fundingRounds.fold<double>(
        0,
        (sum, round) => sum + round.amount,
      );
      displayContent = '\$${totalFunding.toStringAsFixed(1)}M';
    }

    return InkWell(
      onTap: () => _onFeatureTap(_features.indexWhere((feature) => feature['label'] == label)),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: _selectedFeatureIndex == _features.indexWhere((feature) => feature['label'] == label)
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: _selectedFeatureIndex == _features.indexWhere((feature) => feature['label'] == label)
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 8,
                  color: _selectedFeatureIndex == _features.indexWhere((feature) => feature['label'] == label)
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(width: 2),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 6,
                        fontWeight: FontWeight.w500,
                        color: _selectedFeatureIndex == _features.indexWhere((feature) => feature['label'] == label)
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            if (displayContent.isNotEmpty)
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    displayContent,
                    style: TextStyle(
                      fontSize: 5,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}