part of '_index.dart';

final userProvider = ChangeNotifierProvider((ref) => UserProvider(ref));

class UserProvider extends ChangeNotifier {
  List<Skills?>? skills;
  User? user;
  Ref ref;

  SimpleWebSocket? _webSocket;
  BuildContext? _context; // To show notifications

  Dio get http => ref.read(httpProvider).http;

  UserProvider(this.ref) {
    init();
  }

  void init() {
    http.interceptors.add(InterceptorsWrapper(
      onResponse: (res, handler) async {
        if (res.statusCode == 401) {
          // print("Unauthorized");
          await logout();
        }

        return handler.next(res);
      },
    ));
  }

  void setContext(BuildContext context) {
    _context = context;
    print('DEBUG: Context updated - mounted: ${context.mounted}');
  }

  // Call this method from screens that should be able to receive WebSocket notifications
  void updateContext(BuildContext context) {
    if (context.mounted) {
      _context = context;
      print('DEBUG: Context updated from screen - mounted: ${context.mounted}');
    }
  }

  Future<bool> reloadUser() async {
    try {
      final res = await cather(() => http.get("/user/"));
      // print(res.result);
      if (!res.success) return false;
      final data = res.parse(User.fromJson);
      user = data.result;
      notifyListeners();
      return true;
    } catch (e) {
      print('error: $e');
      return false;
    }
  }

  // Connect websocket after login - FIXED VERSION
  Future<Resp<User?>> login(String email, String password) async {
    final res = await cather(
      () => http.post("/auth/login", data: {
        "email": email,
        "password": password,
      }),
    );

    print('resp: ${res.success}');
    if (res.success) {
      final token = res.result["token"];
      await ref.read(httpProvider).setToken(token);
      final resp = res.parse((data) => User.fromJson(data["user"]));
      user = resp.result;

      // Connect websocket with user ID - FIXED: Check for context
      if (user != null && _context != null) {
        print('DEBUG: User ID: ${user!.id}');
        print('DEBUG: Context available: ${_context != null}');
        print('DEBUG: About to connect WebSocket...');
        _connectWebSocket(user!.id.toString(), _context!);
      } else {
        print(
            'DEBUG: Cannot connect WebSocket - User: ${user != null}, Context: ${_context != null}');
      }
      // If no context is available, websocket connection will be skipped
      // Call setContext() before login to ensure websocket works

      return resp;
    }
    return res.toNull();
  }

  // Simple websocket connection
  void _connectWebSocket(String userId, BuildContext context) {
    print('DEBUG: _connectWebSocket called with userId: $userId');
    print('DEBUG: Context mounted in _connectWebSocket: ${context.mounted}');

    _webSocket = SimpleWebSocket();
    _webSocket!.connect(
      userId,
      context,
      (message) {
        print('DEBUG: WebSocket callback received message: $message');

        // Stop upload state when message is received
        _webSocket?.stopUpload();

        // Hide any existing loading snackbar
        if (_context != null && _context!.mounted) {
          ScaffoldMessenger.of(_context!).hideCurrentSnackBar();
        }

        // Update context to current context when callback is triggered
        if (_context != null && _context!.mounted) {
          print('DEBUG: Using stored context for navigation');
          // Show notification when upload is complete
          _showUploadNotification(message);
          // Navigate to home after showing notification
          Future.delayed(Duration(milliseconds: 1500), () {
            if (_context != null && _context!.mounted) {
              print('DEBUG: 🏠 Navigating to home from UserProvider callback');
              Navigator.pushNamedAndRemoveUntil(
                _context!,
                '/home',
                (route) => false,
              );
            }
          });
        } else {
          print(
              'DEBUG: No valid context available for notification/navigation');
        }
        // Reload user data
        reloadUser();
      },
      homeRoute: '/home', // Navigate to HomeScreen after CV processing
    );

    print('DEBUG: WebSocket connect method called');
  }

  // Show simple notification
  void _showUploadNotification(String message) {
    if (_context != null && _context!.mounted) {
      print('DEBUG: Showing upload notification: $message');
      ScaffoldMessenger.of(_context!).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration:
              Duration(seconds: 2), // Shorter duration since we'll navigate
          behavior:
              SnackBarBehavior.floating, // Make it float so it's more visible
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          action: SnackBarAction(
            label: 'View Jobs',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(_context!).hideCurrentSnackBar();
            },
          ),
        ),
      );
    } else {
      print('DEBUG: Cannot show notification - context is null or not mounted');
    }
  }

  // Getter for WebSocket access
  SimpleWebSocket? get webSocket => _webSocket;

  // Disconnect websocket on logout - FIXED VERSION
  Future logout() async {
    _webSocket?.disconnect();
    await ref.read(httpProvider).removeToken();
    user = null;
    notifyListeners(); // Added this
  }

  Future<Resp<User?>> register(
      {required String fullname,
      required String email,
      required String password}) async {
    final res = await cather(
      () => http.post(
        "/auth/register",
        data: {
          "name": fullname,
          "password": password,
          "email": email,
        },
      ),
    );
    if (res.success) {
      return login(email, password);
    }
    return res.toNull();
  }

  Future<Resp<User?>> updateProfile({
    String? location,
    String? portfolio,
    String? about,
    List<String>? language,
    File? image,
  }) async {
    if (image != null) {
      FormData formData = FormData.fromMap({
        "img": await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      });
      await cather(() => http.post('/user/image', data: formData));
      // print(resp);
    }
    final res = await cather(
      () => http.put(
        '/user/profile',
        data: {
          "about": about,
          "location": location,
          "portfolio": portfolio,
          "languages": language,
        },
      ),
    );
    reloadUser();
    return res.toNull();
  }

  Future<Resp<User?>> addExperience({
    required String jobTitle,
    required String companyName,
    required String? startDate,
    String? endDate,
    String? tasks,
    bool? hasCompleted,
  }) async {
    final res = await cather(
      () => http.post(
        '/user/experience',
        data: {
          "job_title": jobTitle,
          "company_name": companyName,
          "start_date": startDate,
          "end_date": endDate,
          "tasks": tasks,
          "has_completed": hasCompleted,
        },
      ),
    );
    reloadUser();
    return res.toNull();
  }

  Future<Resp<User?>> updateExperience({
    required int id,
    required String jobTitle,
    required String companyName,
    required String? startDate,
    String? endDate,
    String? tasks,
    bool? hasCompleted,
  }) async {
    final res = await cather(
      () => http.put(
        '/user/experience',
        data: {
          "id": id,
          "job_title": jobTitle,
          "company_name": companyName,
          "start_date": startDate,
          "end_date": endDate,
          "tasks": tasks,
          "has_completed": hasCompleted,
        },
      ),
    );
    reloadUser();
    return res.toNull();
  }

  Future<Resp<User?>> addEducation({
    required String program,
    required String institution,
    required String? startDate,
    String? endDate,
    bool? hasCompleted,
  }) async {
    final res = await cather(
      () => http.post(
        '/user/education',
        data: {
          "program": program,
          "institution": institution,
          "start_date": startDate,
          "end_date": endDate,
          "has_completed": hasCompleted,
        },
      ),
    );
    reloadUser();
    return res.toNull();
  }

  Future<Resp<User?>> updateEducation({
    required int id,
    required String program,
    required String institution,
    required String? startDate,
    String? endDate,
    bool? hasCompleted,
  }) async {
    final res = await cather(
      () => http.put(
        '/user/education',
        data: {
          "id": id,
          "program": program,
          "institution": institution,
          "start_date": startDate,
          "end_date": endDate,
          "has_completed": hasCompleted,
        },
      ),
    );
    reloadUser();
    return res.toNull();
  }

  // Updated upload resume method with persistent WebSocket
  Future<Resp<User?>> uploadResume({required resume}) async {
    // Start upload process - this will keep WebSocket connected
    _webSocket?.startUpload();

    // Show persistent loading message
    if (_context != null) {
      ScaffoldMessenger.of(_context!).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text('Uploading resume, please wait...'),
              ),
            ],
          ),
          backgroundColor: Colors.blue,
          duration: Duration(minutes: 5), // Longer duration for upload
          behavior: SnackBarBehavior.fixed,
        ),
      );
    }

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        resume.path,
        filename: resume.path.split('/').last,
      ),
    });

    final resp =
        await cather(() => http.post('/user/upload_resume', data: formData));

    // Don't reload here - websocket will handle it
    return resp.toNull();
  }

  Future<Resp<User?>> uploadProfileImage(File imageFile) async {
    FormData formData = FormData.fromMap({
      "img": await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
    });
    final resp = await cather(() => http.post('/user/image', data: formData));

    reloadUser();
    return resp.toNull();
  }

  Future<Resp<User?>> removeResume({url}) async {
    final resp = await cather(() => http.delete('/user/resume', data: {
          "url": url,
        }));
    // print('response: $resp');

    reloadUser();
    return resp.toNull();
  }

  Future<bool> loadSkills() async {
    try {
      final resp = await cather(() => http.get('/user/skills'));
      // print('res: ${res.data}');
      if (!resp.success) return throw Exception("failed");
      final Resp<List<Skills?>> data = resp.parseList(Skills.fromJson);
      skills = data.result;
      notifyListeners();
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool> searchSkill({skill}) async {
    try {
      final resp = await cather(
        () => http.get('/user/skills', queryParameters: {"q": skill}),
      );
      // print('res: ${resp.result}');
      if (!resp.success) return throw Exception("failed");
      final Resp<List<Skills?>> data = resp.parseList(Skills.fromJson);
      skills = data.result;
      notifyListeners();
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<Resp<User?>> uploadSkills({
    required List skills,
  }) async {
    final res = await cather(
      () => http.post(
        '/user/skill',
        data: {
          "skills": skills,
        },
      ),
    );
    reloadUser();
    return res.toNull();
  }

  // New API methods as per guide
  Future getUserPreferences() async {
    final resp = await cather(() => http.get('/user/preferences'));
    if (!resp.success) return throw Exception("failed");
    return resp;
  }

  Future<bool> updateUserPreferences({
    double? minMatchScore,
    List<String>? preferredJobTypes,
    List<String>? preferredLocations,
    Map<String, dynamic>? salaryExpectations,
    bool? enableRemoteJobs,
    bool? enableSemanticMatching,
    bool? autoRefreshMatches,
    double? notificationThreshold,
  }) async {
    final data = <String, dynamic>{};

    if (minMatchScore != null) data['min_match_score'] = minMatchScore;
    if (preferredJobTypes != null)
      data['preferred_job_types'] = preferredJobTypes;
    if (preferredLocations != null)
      data['preferred_locations'] = preferredLocations;
    if (salaryExpectations != null)
      data['salary_expectations'] = salaryExpectations;
    if (enableRemoteJobs != null) data['enable_remote_jobs'] = enableRemoteJobs;
    if (enableSemanticMatching != null)
      data['enable_semantic_matching'] = enableSemanticMatching;
    if (autoRefreshMatches != null)
      data['auto_refresh_matches'] = autoRefreshMatches;
    if (notificationThreshold != null)
      data['notification_threshold'] = notificationThreshold;

    final resp =
        await cather(() => http.patch('/user/preferences', data: data));
    if (!resp.success) return throw Exception("failed");
    notifyListeners();
    return true;
  }

  Future<bool> refreshAllMatches() async {
    final resp = await cather(() => http.post('/user/refresh_all_matches'));
    if (!resp.success) return throw Exception(resp.success);
    notifyListeners();
    return true;
  }
}
