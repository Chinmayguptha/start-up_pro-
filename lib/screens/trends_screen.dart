import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import '../services/trends_service.dart';
import '../models/trend_model.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class TrendsScreen extends StatefulWidget {
  const TrendsScreen({Key? key}) : super(key: key);

  @override
  State<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> with SingleTickerProviderStateMixin {
  String _selectedTimeRange = '1M';
  String _selectedMetric = 'Funding';
  final List<String> _timeRanges = ['1M', '3M', '6M', '1Y', 'All'];
  final List<String> _metrics = ['Funding', 'Deals', 'Valuation'];
  late AnimationController _animationController;
  late Animation<double> _animation;
  final TrendsService _trendsService = TrendsService();
  Timer? _refreshTimer;

  // Data structures
  Map<String, dynamic> _marketData = {};
  List<Trend> _techTrends = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _loadData();
    _animationController.forward();

    // Refresh data every 5 minutes
    _refreshTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final marketData = await _trendsService.getMarketTrends();
      final techTrends = await _trendsService.getTechTrends();

      setState(() {
        _marketData = marketData;
        _techTrends = techTrends;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Trends'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
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
                        onPressed: _loadData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildMarketChart(),
                      const SizedBox(height: 24),
                      _buildTechTrends(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildMarketChart() {
    final dates = _marketData['dates'] as List<String>;
    final values = _marketData['values'] as List<double>;
    final change = _marketData['change'] as String;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tech Sector Performance',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${change}%',
                  style: TextStyle(
                    color: double.parse(change) >= 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= dates.length) return const Text('');
                          final date = dates[value.toInt()];
                          return Text(date.substring(5)); // Show only month-day
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        values.length,
                        (index) => FlSpot(index.toDouble(), values[index]),
                      ),
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechTrends() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tech Trends',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _techTrends.length,
          itemBuilder: (context, index) {
            final trend = _techTrends[index];
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
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }
} 