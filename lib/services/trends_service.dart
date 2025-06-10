import 'dart:math';
import '../models/trend_model.dart';

class TrendsService {
  // Returns a shuffled list of dummy tech trends
  Future<List<Trend>> getTechTrends() async {
    return _getDummyTechTrends();
  }

  Future<Map<String, dynamic>> getMarketTrends() async {
    return _getDummyMarketData();
  }

  List<Trend> _getDummyTechTrends() {
    final now = DateTime.now();
    final List<Trend> trends = [
      Trend(
        title: 'AI Revolution Continues',
        description: 'Cloud services market expected to reach \$500B by 2025',
        source: 'TechCrunch',
        url: 'https://techcrunch.com',
        publishedAt: now.subtract(const Duration(hours: 2)).toIso8601String(),
        category: 'AI & ML',
      ),
      Trend(
        title: 'Blockchain Adoption Grows',
        description: 'Major banks announce blockchain integration plans',
        source: 'CoinDesk',
        url: 'https://coindesk.com',
        publishedAt: now.subtract(const Duration(hours: 4)).toIso8601String(),
        category: 'Blockchain',
      ),
      Trend(
        title: '5G Rollout Accelerates',
        description: 'Global 5G subscriptions to reach 1B by 2024',
        source: 'The Verge',
        url: 'https://theverge.com',
        publishedAt: now.subtract(const Duration(hours: 6)).toIso8601String(),
        category: 'Telecom',
      ),
      Trend(
        title: 'Quantum Computing Milestone',
        description: 'Quantum computers solve complex problems faster than ever.',
        source: 'Quantum Weekly',
        url: 'https://quantamagazine.org',
        publishedAt: now.subtract(const Duration(days: 1)).toIso8601String(),
        category: 'Quantum',
      ),
      Trend(
        title: 'Cybersecurity Innovation',
        description: 'Startups develop new ways to protect data online.',
        source: 'Security Today',
        url: 'https://securityweek.com',
        publishedAt: now.subtract(const Duration(days: 2)).toIso8601String(),
        category: 'Cybersecurity',
      ),
      Trend(
        title: 'Edge Computing Expands',
        description: 'Edge devices process data closer to the source.',
        source: 'EdgeTech',
        url: 'https://edgetech.com',
        publishedAt: now.subtract(const Duration(days: 3)).toIso8601String(),
        category: 'Edge Computing',
      ),
      Trend(
        title: 'IoT Devices Everywhere',
        description: 'Internet of Things devices are now in every home.',
        source: 'IoT News',
        url: 'https://iotnews.com',
        publishedAt: now.subtract(const Duration(days: 4)).toIso8601String(),
        category: 'IoT',
      ),
      Trend(
        title: 'Augmented Reality in Retail',
        description: 'AR is changing the way we shop.',
        source: 'AR/VR News',
        url: 'https://arvrtips.com',
        publishedAt: now.subtract(const Duration(days: 5)).toIso8601String(),
        category: 'AR/VR',
      ),
      Trend(
        title: 'Sustainable Tech Solutions',
        description: 'Green tech is making a difference.',
        source: 'Green Tech Review',
        url: 'https://greentechmedia.com',
        publishedAt: now.subtract(const Duration(days: 6)).toIso8601String(),
        category: 'Sustainability',
      ),
      Trend(
        title: 'Fintech Startups Disrupt Banking',
        description: 'Fintech is changing how we manage money.',
        source: 'Fintech News',
        url: 'https://fintechfutures.com',
        publishedAt: now.subtract(const Duration(days: 7)).toIso8601String(),
        category: 'Fintech',
      ),
      Trend(
        title: 'HealthTech Improves Patient Care',
        description: 'HealthTech startups are transforming healthcare.',
        source: 'HealthTech Insider',
        url: 'https://healthtechinsider.com',
        publishedAt: now.subtract(const Duration(days: 8)).toIso8601String(),
        category: 'HealthTech',
      ),
      Trend(
        title: 'EdTech Makes Learning Fun',
        description: 'EdTech platforms are engaging students worldwide.',
        source: 'EdTech Magazine',
        url: 'https://edtechmagazine.com',
        publishedAt: now.subtract(const Duration(days: 9)).toIso8601String(),
        category: 'EdTech',
      ),
    ];
    trends.shuffle(Random());
    return trends;
  }

  Map<String, dynamic> _getDummyMarketData() {
    final now = DateTime.now();
    final random = Random();
    
    // Generate more realistic market data with natural fluctuations
    double baseValue = 100.0;
    double trend = 0.5; // Overall upward trend
    double volatility = 2.0; // Daily volatility
    List<double> values = [];
    
    for (int i = 0; i < 30; i++) {
      // Add random walk component
      double randomWalk = (random.nextDouble() - 0.5) * volatility;
      
      // Add some momentum (previous day's movement influences next day)
      double momentum = i > 0 ? (values[i-1] - (i > 1 ? values[i-2] : baseValue)) * 0.3 : 0;
      
      // Add some mean reversion (tendency to return to trend)
      double meanReversion = (baseValue + (i * trend) - (i > 0 ? values[i-1] : baseValue)) * 0.1;
      
      // Calculate new value
      double newValue = baseValue + (i * trend) + randomWalk + momentum + meanReversion;
      
      // Add occasional market events (larger movements)
      if (random.nextDouble() < 0.1) { // 10% chance of market event
        newValue += (random.nextDouble() - 0.5) * volatility * 3;
      }
      
      values.add(newValue);
    }
    
    // Calculate percentage change
    double firstValue = values.first;
    double lastValue = values.last;
    double change = ((lastValue - firstValue) / firstValue) * 100;
    
    return {
      'dates': List.generate(30, (index) {
        final date = now.subtract(Duration(days: 29 - index));
        return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      }),
      'values': values,
      'change': change.toStringAsFixed(2),
    };
  }
} 