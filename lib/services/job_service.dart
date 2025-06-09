import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/job_model.dart';

class JobService {
  // Using GitHub Jobs API as an example (you can replace with other job APIs)
  static const String _baseUrl = 'https://jobs.github.com/positions.json';

  Future<List<JobModel>> getJobs({
    String? search,
    String? location,
    String? type,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (search != null) queryParams['search'] = search;
      if (location != null) queryParams['location'] = location;
      if (type != null) queryParams['type'] = type;

      final uri = Uri.parse(_baseUrl).replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => JobModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load jobs');
      }
    } catch (e) {
      // If API fails, return dummy data
      return getDummyJobs();
    }
  }

  // For demo purposes, return some dummy data
  List<JobModel> getDummyJobs() {
    return [
      JobModel(
        id: '1',
        title: 'Senior Flutter Developer',
        company: 'TechCorp',
        location: 'Remote',
        description: 'Looking for an experienced Flutter developer to join our team. You will be responsible for developing and maintaining our mobile applications using Flutter framework.',
        type: 'Full-time',
        url: 'https://www.linkedin.com/jobs/view/senior-flutter-developer',
        postedDate: '2024-03-15',
        skills: ['Flutter', 'Dart', 'Firebase', 'REST APIs'],
        salary: '\$80,000 - \$120,000',
        experience: '3+ years',
      ),
      JobModel(
        id: '2',
        title: 'Backend Developer',
        company: 'StartupX',
        location: 'New York, NY',
        description: 'Join our growing team as a backend developer. You will be working on scalable cloud-based solutions and microservices architecture.',
        type: 'Full-time',
        url: 'https://www.indeed.com/job/backend-developer',
        postedDate: '2024-03-14',
        skills: ['Node.js', 'Python', 'AWS', 'Docker'],
        salary: '\$90,000 - \$130,000',
        experience: '2+ years',
      ),
      JobModel(
        id: '3',
        title: 'DevOps Engineer',
        company: 'CloudTech',
        location: 'San Francisco, CA',
        description: 'We are seeking a DevOps Engineer to help us build and maintain our cloud infrastructure and CI/CD pipelines.',
        type: 'Full-time',
        url: 'https://www.glassdoor.com/job/devops-engineer',
        postedDate: '2024-03-13',
        skills: ['Kubernetes', 'Docker', 'AWS', 'Jenkins'],
        salary: '\$100,000 - \$150,000',
        experience: '4+ years',
      ),
      JobModel(
        id: '4',
        title: 'Frontend Developer',
        company: 'WebSolutions',
        location: 'Remote',
        description: 'Looking for a Frontend Developer with strong React skills to join our team and help build modern web applications.',
        type: 'Contract',
        url: 'https://www.remote.com/jobs/frontend-developer',
        postedDate: '2024-03-12',
        skills: ['React', 'JavaScript', 'TypeScript', 'CSS'],
        salary: '\$70,000 - \$100,000',
        experience: '2+ years',
      ),
      JobModel(
        id: '5',
        title: 'Data Scientist',
        company: 'AI Innovations',
        location: 'Boston, MA',
        description: 'Join our AI team to work on cutting-edge machine learning projects and data analysis.',
        type: 'Full-time',
        url: 'https://www.dice.com/job/data-scientist',
        postedDate: '2024-03-11',
        skills: ['Python', 'Machine Learning', 'TensorFlow', 'SQL'],
        salary: '\$95,000 - \$140,000',
        experience: '3+ years',
      ),
    ];
  }
} 