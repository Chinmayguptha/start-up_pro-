class FundingModel {
  final String round;
  final double amount;
  final String date;
  final String? leadInvestor;
  final String companyId;

  FundingModel({
    required this.round,
    required this.amount,
    required this.date,
    this.leadInvestor,
    required this.companyId,
  });

  factory FundingModel.fromJson(Map<String, dynamic> json) {
    return FundingModel(
      round: json['round'] as String,
      amount: json['amount'] as double,
      date: json['date'] as String,
      leadInvestor: json['leadInvestor'] as String?,
      companyId: json['companyId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'round': round,
      'amount': amount,
      'date': date,
      'leadInvestor': leadInvestor,
      'companyId': companyId,
    };
  }
} 