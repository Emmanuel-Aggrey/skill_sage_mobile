part of '_index.dart';

final jobProvider = ChangeNotifierProvider((ref) => JobProvider(ref));

class JobProvider extends ChangeNotifier {
  Ref ref;
  List<dynamic> bookmarks = [];
  List<dynamic> applications = [];
  List<dynamic> recommendedJobs = [];
  List<dynamic> externalJobs = [];
  List<dynamic> allRecommendedJobs = [];

  Dio get http => ref.read(httpProvider).http;
  JobProvider(this.ref) {
    init();
  }

  void init() {
    http.interceptors.add(InterceptorsWrapper(
      onResponse: (res, handler) async {
        if (res.statusCode == 401) {
          print("Unauthorized");
          // await logout();
        }

        return handler.next(res);
      },
    ));
  }

  Future loadJobs() async {
    final resp = await cather(() => http.get('/job'));
    if (!resp.success) return throw Exception("failed");
    notifyListeners();
    return resp;
  }

  Future<bool> addBookmark({id}) async {
    final resp = await cather(() => http.post('/job/bookmark/$id'));
    print(resp.success);
    if (!resp.success) return throw Exception("failed");
    notifyListeners();
    return true;
  }

  Future loadBookmark() async {
    final resp = await cather(() => http.get('/job/bookmarks'));
    if (!resp.success) return throw Exception("failed");
    bookmarks = resp.result;
    notifyListeners();
    return resp;
  }

  Future<bool> removeBookmark({id}) async {
    print(id);
    final resp = await cather(() => http.delete('/job/bookmarks/$id'));
    if (!resp.success) return throw Exception("failed");
    loadBookmark();
    notifyListeners();
    return true;
  }

  Future<bool> addApplication({id}) async {
    final resp = await cather(() => http.post('/job/application/$id'));
    print(resp.success);
    if (!resp.success) return throw Exception("failed");
    notifyListeners();
    return true;
  }

  Future loadApplications() async {
    final resp = await cather(() => http.get('/job/applications'));
    if (!resp.success) return throw Exception("failed");
    applications = resp.result;
    notifyListeners();
    return resp;
  }

  Future<bool> removeApplication({id}) async {
    print(id);
    final resp = await cather(() => http.delete('/job/application/$id'));
    if (!resp.success) return throw Exception("failed");
    loadApplications();
    return true;
  }

  // Job Recommendations
  Future loadRecommendedJobs({int limit = 20}) async {
    final resp =
        await cather(() => http.get('/user/recommend_jobs?limit=$limit'));
    if (!resp.success) return throw Exception("failed");
    recommendedJobs = resp.result;
    notifyListeners();
    return resp;
  }

  Future loadJobPreferences() async {
    final resp = await cather(() => http.get('/user/job_preferences'));
    if (!resp.success) return throw Exception("failed");
    notifyListeners();
    return resp;
  }

  Future<bool> updateJobPreferences({
    List<String>? preferredLocations,
    List<String>? preferredJobTypes,
    double? minSalary,
    double? maxSalary,
    bool? remoteOk,
  }) async {
    final data = {
      'preferred_locations': preferredLocations ?? [],
      'preferred_job_types': preferredJobTypes ?? [],
      'min_salary': minSalary,
      'max_salary': maxSalary,
      'remote_ok': remoteOk ?? false,
    };

    final resp =
        await cather(() => http.post('/user/job_preferences', data: data));
    if (!resp.success) return throw Exception("failed");
    notifyListeners();
    return true;
  }

  // External Jobs
  Future loadExternalJobs({int limit = 50, String? source}) async {
    String url = '/user/external_jobs?limit=$limit';
    if (source != null) {
      url += '&source=$source';
    }
    final resp = await cather(() => http.get(url));
    if (!resp.success) return throw Exception("failed");
    externalJobs = resp.result;
    notifyListeners();
    return resp;
  }

  Future loadRecommendedExternalJobs({int limit = 20}) async {
    final resp = await cather(
        () => http.get('/user/recommend_external_jobs?limit=$limit'));
    if (!resp.success) return throw Exception("failed");
    notifyListeners();
    return resp;
  }

  Future loadAllRecommendedJobs(
      {int limit = 20, double minMatchScore = 40.0}) async {
    print(
        'Loading all recommended jobs with limit: $limit, min_match_score: $minMatchScore');
    final resp = await cather(() => http.get(
        '/user/me/recommendations?min_match_score=${minMatchScore.toInt()}&limit=$limit'));
    print('API response success: ${resp.success}');

    if (resp.success) {
      final responseData = resp.result ?? [];
      print('API response result length: ${responseData.length}');

      // The API returns the jobs directly in the result array
      // No need to extract from job match objects
      List<dynamic> jobData = responseData;

      print('Jobs count: ${jobData.length}');
      if (jobData.isNotEmpty) {
        final externalCount = jobData
            .where(
                (job) => job['source'] != null && job['source'] != 'Internal')
            .length;
        final internalCount = jobData
            .where(
                (job) => job['source'] == null || job['source'] == 'Internal')
            .length;
        print('External jobs in response: $externalCount');
        print('Internal jobs in response: $internalCount');
      }
      allRecommendedJobs = jobData;
    } else {
      print('API response error: ${resp.error}');
      if (!resp.success) return throw Exception("failed");
    }
    notifyListeners();
    return resp;
  }

  Future<bool> scrapeExternalJobs() async {
    final resp = await cather(() => http.post('/user/scrape_jobs'));
    if (!resp.success) return throw Exception("failed");
    notifyListeners();
    return true;
  }

  // New API methods as per guide
  Future extractSkillsFromJobRecommendations() async {
    final resp = await cather(
        () => http.get('/user/extract_skills_from_job_recommendations'));
    if (!resp.success) return throw Exception("failed");
    notifyListeners();
    print(resp);
    print(resp.result);
    return resp;
  }

  Future getDetailedMatchAnalysis(String source, int jobId,
      {bool includeImprovementPlan = true,
      bool includeSimilarItems = true,
      bool forceRefresh = false}) async {
    final resp = await cather(() => http.get(
        '/user/detailed_match_analysis/$source/$jobId/?include_improvement_plan=$includeImprovementPlan&include_similar_items=$includeSimilarItems&force_refresh=$forceRefresh'));

    if (!resp.success) return throw Exception(resp.result);

    return resp;
  }
}

// response!.data
