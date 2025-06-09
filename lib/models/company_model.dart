import 'funding_model.dart';

class CompanyModel {
  final String id;
  final String name;
  final String description;
  final String domain;
  final String? logoUrl;
  final String partnerships;
  final String funding;
  final String ceo;
  final String team;
  final String location;
  final String contact;
  final String founder;
  final String stage;
  final int yearFounded;
  bool bookmarked;
  final List<FundingModel> fundingRounds;

  CompanyModel({
    required this.id,
    required this.name,
    required this.description,
    required this.domain,
    this.logoUrl,
    this.partnerships = '',
    this.funding = '',
    this.ceo = '',
    this.team = '',
    this.location = '',
    this.contact = '',
    this.founder = '',
    this.stage = '',
    this.yearFounded = 0,
    this.bookmarked = false,
    required this.fundingRounds,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      domain: json['domain'] as String,
      logoUrl: json['logoUrl'] as String?,
      partnerships: json['partnerships'] as String? ?? '',
      funding: json['funding'] as String? ?? '',
      ceo: json['ceo'] as String? ?? '',
      team: json['team'] as String? ?? '',
      location: json['location'] as String? ?? '',
      contact: json['contact'] as String? ?? '',
      founder: json['founder'] as String? ?? '',
      stage: json['stage'] as String? ?? '',
      yearFounded: json['yearFounded'] as int? ?? 0,
      bookmarked: json['bookmarked'] ?? false,
      fundingRounds: (json['fundingRounds'] as List)
          .map((e) => FundingModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'domain': domain,
      'logoUrl': logoUrl,
      'partnerships': partnerships,
      'funding': funding,
      'ceo': ceo,
      'team': team,
      'location': location,
      'contact': contact,
      'founder': founder,
      'stage': stage,
      'yearFounded': yearFounded,
      'bookmarked': bookmarked,
      'fundingRounds': fundingRounds.map((e) => e.toJson()).toList(),
    };
  }

  static List<CompanyModel> getDummyCompanies() {
    return [
      CompanyModel(
        id: '1',
        name: 'TechVision AI',
        domain: 'techvisionai.com',
        founder: 'Alex Chen',
        location: 'San Francisco, CA',
        yearFounded: 2020,
        stage: 'Series A',
        description: 'Leading AI solutions for enterprise automation',
        logoUrl: 'https://picsum.photos/200',
        fundingRounds: [
          FundingModel(
            round: 'Seed',
            amount: 2.5,
            date: '2020-06',
            leadInvestor: 'Y Combinator',
            companyId: '1',
          ),
          FundingModel(
            round: 'Series A',
            amount: 25.0,
            date: '2022-03',
            leadInvestor: 'Andreessen Horowitz',
            companyId: '1',
          ),
        ],
        partnerships: 'Microsoft, NVIDIA, Intel',
        ceo: 'Alex Chen',
        team: '50+ employees',
        contact: 'contact@techvisionai.com',
      ),
      CompanyModel(
        id: '2',
        name: 'GreenEnergy Solutions',
        domain: 'greenenergysol.com',
        founder: 'Sarah Johnson',
        location: 'Austin, TX',
        yearFounded: 2019,
        stage: 'Series B',
        description: 'Renewable energy technology for sustainable future',
        logoUrl: 'https://picsum.photos/200',
        fundingRounds: [
          FundingModel(
            round: 'Seed',
            amount: 3.0,
            date: '2019-09',
            leadInvestor: 'Sequoia Capital',
            companyId: '2',
          ),
          FundingModel(
            round: 'Series A',
            amount: 15.0,
            date: '2021-02',
            leadInvestor: 'Kleiner Perkins',
            companyId: '2',
          ),
          FundingModel(
            round: 'Series B',
            amount: 40.0,
            date: '2023-01',
            leadInvestor: 'Tiger Global',
            companyId: '2',
          ),
        ],
        partnerships: 'Tesla, SolarCity, GE',
        ceo: 'Sarah Johnson',
        team: '75+ employees',
        contact: 'contact@greenenergysol.com',
      ),
    ];
  }
}

class FundingRound {
  final String round;
  final double amount;
  final String leadInvestor;

  FundingRound({
    required this.round,
    required this.amount,
    required this.leadInvestor,
  });
}

class PressRelease {
  final String title;
  final DateTime date;
  final String url;

  PressRelease({
    required this.title,
    required this.date,
    required this.url,
  });
}

class News {
  final String title;
  final String source;
  final DateTime date;
  final String url;

  News({
    required this.title,
    required this.source,
    required this.date,
    required this.url,
  });
}

class Event {
  final String name;
  final DateTime date;
  final String location;
  final String url;

  Event({
    required this.name,
    required this.date,
    required this.location,
    required this.url,
  });
}

class Award {
  final String name;
  final String organization;
  final DateTime date;
  final String url;

  Award({
    required this.name,
    required this.organization,
    required this.date,
    required this.url,
  });
}

class Testimonial {
  final String quote;
  final String author;
  final String position;
  final String company;
  final String url;

  Testimonial({
    required this.quote,
    required this.author,
    required this.position,
    required this.company,
    required this.url,
  });
}

class CaseStudy {
  final String title;
  final String client;
  final String industry;
  final String url;

  CaseStudy({
    required this.title,
    required this.client,
    required this.industry,
    required this.url,
  });
}

class Product {
  final String name;
  final String description;
  final String url;

  Product({
    required this.name,
    required this.description,
    required this.url,
  });
}

class Service {
  final String name;
  final String description;
  final String url;

  Service({
    required this.name,
    required this.description,
    required this.url,
  });
}

class Resource {
  final String title;
  final String type;
  final String url;

  Resource({
    required this.title,
    required this.type,
    required this.url,
  });
}

class FAQ {
  final String question;
  final String answer;
  final String category;

  FAQ({
    required this.question,
    required this.answer,
    required this.category,
  });
}

class TeamMember {
  final String name;
  final String position;
  final String bio;
  final String imageUrl;
  final String linkedin;

  TeamMember({
    required this.name,
    required this.position,
    required this.bio,
    required this.imageUrl,
    required this.linkedin,
  });
}

class Investor {
  final String name;
  final String type;
  final String url;

  Investor({
    required this.name,
    required this.type,
    required this.url,
  });
}

class Partner {
  final String name;
  final String type;
  final String url;

  Partner({
    required this.name,
    required this.type,
    required this.url,
  });
}

class Competitor {
  final String name;
  final String description;
  final String url;

  Competitor({
    required this.name,
    required this.description,
    required this.url,
  });
} 