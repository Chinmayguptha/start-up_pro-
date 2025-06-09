class JobModel {
  final String id;
  final String title;
  final String company;
  final String location;
  final String description;
  final String type; // Full-time, Part-time, Contract, etc.
  final String url;
  final String postedDate;
  final List<String> skills;
  final String salary;
  final String experience;

  JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    required this.type,
    required this.url,
    required this.postedDate,
    required this.skills,
    required this.salary,
    required this.experience,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) => JobModel(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        company: json['company'] ?? '',
        location: json['location'] ?? '',
        description: json['description'] ?? '',
        type: json['type'] ?? 'Full-time',
        url: json['url'] ?? '',
        postedDate: json['postedDate'] ?? '',
        skills: List<String>.from(json['skills'] ?? []),
        salary: json['salary'] ?? 'Not specified',
        experience: json['experience'] ?? 'Not specified',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'company': company,
        'location': location,
        'description': description,
        'type': type,
        'url': url,
        'postedDate': postedDate,
        'skills': skills,
        'salary': salary,
        'experience': experience,
      };
} 