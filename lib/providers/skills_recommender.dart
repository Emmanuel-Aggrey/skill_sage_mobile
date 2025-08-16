part of '_index.dart';

final skillsRecommenderProvider =
    ChangeNotifierProvider((ref) => SkillsRecommenderProvider(ref));

class SkillsRecommenderProvider extends ChangeNotifier {
  Ref ref;
  List<String> recommendedSkills = [];
  bool isLoading = false;

  Dio get http => ref.read(httpProvider).http;

  SkillsRecommenderProvider(this.ref);

  Future<List<String>> getSkillRecommendations(List<String> skills,
      {int limit = 10}) async {
    if (skills.isEmpty) return [];

    isLoading = true;
    notifyListeners();

    try {
      // Try skills recommender service first
      final response = await http.post(
        'http://localhost:5000/recommend',
        data: {
          'skills': skills,
          'limit': limit,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final recommendations =
            List<String>.from(response.data['recommendations'] ?? []);
        recommendedSkills = recommendations;
        isLoading = false;
        notifyListeners();
        return recommendations;
      }
    } catch (e) {
      print('Skills recommender service error: $e');
    }

    // Fallback to basic recommendations
    try {
      final fallbackRecommendations =
          await _getFallbackRecommendations(skills, limit);
      recommendedSkills = fallbackRecommendations;
      isLoading = false;
      notifyListeners();
      return fallbackRecommendations;
    } catch (e) {
      print('Fallback recommendations error: $e');
      isLoading = false;
      notifyListeners();
      return [];
    }
  }

  Future<List<String>> _getFallbackRecommendations(
      List<String> skills, int limit) async {
    // Simple fallback recommendations based on common skill combinations
    final Map<String, List<String>> skillMap = {
      // 'python': ['django', 'flask', 'pandas', 'numpy', 'machine learning', 'data science'],
      // 'javascript': ['react', 'node.js', 'express', 'vue.js', 'angular', 'typescript'],
      // 'java': ['spring', 'hibernate', 'maven', 'gradle', 'android', 'kotlin'],
      // 'react': ['redux', 'next.js', 'typescript', 'material-ui', 'styled-components'],
      // 'node.js': ['express', 'mongodb', 'postgresql', 'redis', 'docker'],
      // 'html': ['css', 'javascript', 'bootstrap', 'sass', 'responsive design'],
      // 'css': ['sass', 'less', 'bootstrap', 'tailwind', 'flexbox', 'grid'],
      // 'sql': ['postgresql', 'mysql', 'mongodb', 'database design', 'data modeling'],
      // 'git': ['github', 'gitlab', 'version control', 'ci/cd', 'devops'],
      // 'docker': ['kubernetes', 'aws', 'devops', 'microservices', 'containerization'],
      // 'aws': ['ec2', 's3', 'lambda', 'rds', 'cloudformation', 'terraform'],
      // 'machine learning': ['tensorflow', 'pytorch', 'scikit-learn', 'data science', 'ai'],
      // 'flutter': ['dart', 'firebase', 'android', 'ios', 'mobile development'],
      // 'android': ['kotlin', 'java', 'firebase', 'material design', 'mvvm'],
      // 'ios': ['swift', 'objective-c', 'xcode', 'cocoapods', 'core data'],
    };

    Set<String> recommendations = {};

    for (String skill in skills) {
      final skillLower = skill.toLowerCase();
      if (skillMap.containsKey(skillLower)) {
        recommendations.addAll(skillMap[skillLower]!);
      }

      // Add related skills based on partial matches
      for (String key in skillMap.keys) {
        if (skillLower.contains(key) || key.contains(skillLower)) {
          recommendations.addAll(skillMap[key]!);
        }
      }
    }

    // Remove input skills from recommendations
    final inputSkillsLower = skills.map((s) => s.toLowerCase()).toSet();
    recommendations
        .removeWhere((rec) => inputSkillsLower.contains(rec.toLowerCase()));

    return recommendations.take(limit).toList();
  }

  Future<List<String>> getSkillRecommendationsForJob(
      Map<String, dynamic> job) async {
    final jobSkills = job['skills'] as List<dynamic>?;
    if (jobSkills == null || jobSkills.isEmpty) {
      return [];
    }

    final skills = jobSkills.map((skill) => skill.toString()).toList();
    return getSkillRecommendations(skills, limit: 5);
  }

  void clearRecommendations() {
    recommendedSkills.clear();
    notifyListeners();
  }
}
