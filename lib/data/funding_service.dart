import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/funding_model.dart';
import 'fundings.dart'; // Import dummy data

class FundingService {
  // Singleton pattern
  static final FundingService _instance = FundingService._internal();
  factory FundingService() => _instance;
  FundingService._internal();

  // Stream controller for real-time updates
  final _fundingController = StreamController<List<FundingModel>>.broadcast();
  Stream<List<FundingModel>> get fundingStream => _fundingController.stream;

  // Cache for the latest data
  List<FundingModel> _latestData = dummyFundings;

  // Initialize the service
  Future<void> initialize() async {
    try {
      // Initialize with dummy data
      _latestData = List<FundingModel>.from(dummyFundings);
      _fundingController.add(_latestData);
      
      // Simulate real-time updates with dummy data
      Timer.periodic(const Duration(seconds: 30), (_) {
        if (!_fundingController.isClosed) {
          // Simulate some data changes
          final updatedData = List<FundingModel>.from(_latestData);
          // Randomly modify some amounts to simulate changes
          for (var i = 0; i < updatedData.length; i++) {
            if (i % 2 == 0) { // Modify every other entry
              final random = DateTime.now().millisecondsSinceEpoch % 100;
              final newAmount = updatedData[i].amount + (random / 10);
              updatedData[i] = FundingModel(
                round: updatedData[i].round,
                amount: newAmount,
                date: updatedData[i].date,
                leadInvestor: updatedData[i].leadInvestor,
                companyId: updatedData[i].companyId,
              );
            }
          }
          _latestData = updatedData;
          _fundingController.add(updatedData);
        }
      });
    } catch (e) {
      if (!_fundingController.isClosed) {
        _fundingController.addError(e);
      }
    }
  }

  // Get the latest data
  List<FundingModel> getLatestFundings() {
    return _latestData;
  }

  // Dispose the service
  void dispose() {
    if (!_fundingController.isClosed) {
      _fundingController.close();
    }
  }
} 