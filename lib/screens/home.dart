part of '_index.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  String searchQuery = "";
  List<dynamic> allJobs = [];
  List<dynamic> filteredJobs = [];
  bool isSkillRecommendationsExpanded = true;

  ScrollController? _jobListScrollController;
  double _lastScrollOffset = 0.0;

  // Animation controllers
  late AnimationController _fabAnimationController;
  late AnimationController _listAnimationController;
  late Animation<double> _fabAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _jobListScrollController = ScrollController();
    _jobListScrollController!.addListener(_onJobListScroll);
    _loadAllJobs();
    _loadSkillRecommendations();

    // Initialize animation controllers
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fabAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _fabAnimationController, curve: Curves.elasticOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _listAnimationController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    Future.delayed(const Duration(milliseconds: 500), () {
      _fabAnimationController.forward();
      _listAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _listAnimationController.dispose();
    _jobListScrollController?.removeListener(_onJobListScroll);
    _jobListScrollController?.dispose();
    super.dispose();
  }

  void _onJobListScroll() {
    if (_jobListScrollController == null) return;

    final currentScrollOffset = _jobListScrollController!.offset;

    // Hide skills when scrolling down (away from top)
    if (currentScrollOffset > _lastScrollOffset &&
        isSkillRecommendationsExpanded &&
        currentScrollOffset > 30) {
      // Hide when scrolling down
      setState(() {
        isSkillRecommendationsExpanded = false;
      });
    }
    // Show skills when scrolling back to top
    else if (currentScrollOffset <= 20 && !isSkillRecommendationsExpanded) {
      setState(() {
        isSkillRecommendationsExpanded = true;
      });
    }

    _lastScrollOffset = currentScrollOffset;
  }

  Future<void> _loadAllJobs() async {
    try {
      final jobProv = ref.read(jobProvider);
      await jobProv.loadAllRecommendedJobs();
      setState(() {
        allJobs = jobProv.allRecommendedJobs;
        filteredJobs = allJobs;
      });
      print('Loaded ${allJobs.length} jobs');
      print(
          'External jobs: ${allJobs.where((job) => (job['source']?.toString() ?? '').isNotEmpty && job['source'] != 'Internal').length}');
      print(
          'Internal jobs: ${allJobs.where((job) => (job['source']?.toString() ?? '').isEmpty || job['source'] == 'Internal').length}');
    } catch (e) {
      print('Error loading jobs: $e');
    }
  }

  Future<void> _loadSkillRecommendations() async {
    try {
      final recommenderProv = ref.read(recommenderProvider.notifier);
      await recommenderProv.loadRecommendations();
    } catch (e) {
      print('Error loading skill recommendations: $e');
    }
  }

  void _filterJobs(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredJobs = allJobs;
      } else {
        filteredJobs = allJobs.where((job) {
          final title = job['title']?.toString().toLowerCase() ?? '';
          final company = job['company']?.toString().toLowerCase() ?? '';
          final location = job['location']?.toString().toLowerCase() ?? '';
          final skills = job['skills']?.join(' ').toLowerCase() ?? '';
          final searchLower = query.toLowerCase();

          return title.contains(searchLower) ||
              company.contains(searchLower) ||
              location.contains(searchLower) ||
              skills.contains(searchLower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.appTheme(context);
    return Scaffold(
      backgroundColor: appTheme.bg1,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _buildScreens(),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BottomNavigationBar(
            backgroundColor: appTheme.primary1,
            currentIndex: _currentIndex,
            selectedItemColor: appTheme.primary2Light,
            unselectedItemColor: Colors.grey[400],
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            onTap: (index) {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
              );
            },
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Icon(CupertinoIcons.home, size: 22),
                ),
                label: '',
                tooltip: 'Home page view of recommended skills and jobs',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Icon(CupertinoIcons.briefcase, size: 22),
                ),
                label: '',
                tooltip: 'Internal job postings',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Icon(CupertinoIcons.bookmark, size: 22),
                ),
                label: '',
                tooltip: 'Bookmarked skills',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Icon(CupertinoIcons.person, size: 22),
                ),
                label: '',
                tooltip: 'User\'s profile view',
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildScreens() {
    final textTheme = CustomTextTheme.customTextTheme(context).textTheme;
    return <Widget>[
      SafeArea(
        child: Column(
          children: [
            // Enhanced header with gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue[50]!,
                    Colors.white,
                  ],
                ),
              ),
              child: CustomAppHeader(onSearchChanged: _filterJobs),
            ),

            // Main content with slide animation
            Expanded(
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Enhanced Skills Recommendations Section
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                isSkillRecommendationsExpanded =
                                    !isSkillRecommendationsExpanded;
                              });
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.lightbulb_outline,
                                      color: Colors.blue[600],
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      "Skill Recommendations",
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  AnimatedRotation(
                                    turns: isSkillRecommendationsExpanded
                                        ? 0.5
                                        : 0,
                                    duration: const Duration(milliseconds: 300),
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Updated Skills Content
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            //  height: isSkillRecommendationsExpanded ? 180 : 0,
                            height: isSkillRecommendationsExpanded ? 180 : 0,

                            constraints: isSkillRecommendationsExpanded
                                ? const BoxConstraints(
                                    maxHeight: 200) // Set max height instead
                                : const BoxConstraints(maxHeight: 0),

                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity:
                                  isSkillRecommendationsExpanded ? 1.0 : 0.0,
                              child: AdvancedFutureBuilder(
                                future: () => ref
                                    .watch(recommenderProvider)
                                    .loadRecommendations(),
                                builder: (context, snapshot, _) {
                                  // Handle the new API response format

                                  final skills =
                                      snapshot.result as List<dynamic>? ?? [];

                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: skills.length,
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    itemBuilder: (_, index) {
                                      final skill =
                                          skills[index] as Map<String, dynamic>;
                                      final skillName =
                                          skill['name'] as String? ?? '';
                                      final skillType =
                                          skill['type'] as String? ?? '';

                                      return Container(
                                        width: 200,
                                        margin:
                                            const EdgeInsets.only(right: 12),
                                        child: SkillCard(
                                          title: skillName,
                                          skillType:
                                              skillType, // Pass the skill type
                                          onPressed: () => Navigator.pushNamed(
                                              context, AppRoutes.coursesRoute,
                                              arguments: {"skill": skillName}),
                                        ),
                                      );
                                    },
                                  );
                                },
                                errorBuilder: (context, error, reload) =>
                                    Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        error.toString(),
                                        style: textTheme.labelSmall,
                                      ),
                                      TextButton(
                                        onPressed: reload,
                                        child: const Text("reload"),
                                      )
                                    ],
                                  ),
                                ),
                                emptyBuilder: (context, reload) => Center(
                                  child: Text("No skill recommendations",
                                      style: textTheme.labelSmall),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Enhanced Job Recommendations Header
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.work_outline,
                              color: Colors.green[600],
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Job Recommendations",
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ScaleTransition(
                            scale: _fabAnimation,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: _showJobFilters,
                                    icon: const Icon(Icons.tune, size: 20),
                                    tooltip: 'Filter Jobs',
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 20,
                                    color: Colors.grey[300],
                                  ),
                                  TextButton(
                                    onPressed: _showAllJobs,
                                    child: Text(
                                      "View All",
                                      style: textTheme.labelSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Enhanced Job List
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _loadAllJobs,
                        color: Colors.blue[600],
                        child: filteredJobs.isEmpty
                            ? _buildEmptyState(textTheme)
                            : ListView.builder(
                                controller: _jobListScrollController,
                                physics: const BouncingScrollPhysics(),
                                itemCount: filteredJobs.length,
                                padding: const EdgeInsets.only(bottom: 20),
                                itemBuilder: (context, index) {
                                  final job = filteredJobs[index];
                                  return AnimatedContainer(
                                    duration: Duration(
                                        milliseconds: 200 + (index * 50)),
                                    curve: Curves.easeOutCubic,
                                    child: _buildEnhancedJobCard(
                                        job, textTheme, index),
                                  );
                                },
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      const JobPostScreen(),
      const BookmarkScreen(),
      const ProfileScreen(),
    ];
  }

  Widget _buildEmptyState(TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Image.asset(
                  "assets/images/not_found.png",
                  height: 120,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 20),
                Text(
                  searchQuery.isEmpty
                      ? "No job recommendations available"
                      : "No jobs found for '$searchQuery'",
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _loadAllJobs,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Reload"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedJobCard(
      Map<String, dynamic> job, TextTheme textTheme, int index) {
    // Determine if job is external based on source field as per API guide
    final source = job['source']?.toString() ?? '';
    final isExternal = source.isNotEmpty && source != 'Internal';
    final matchScore = job['match_score']?.toDouble() ?? 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        child: InkWell(
          onTap: () => _showJobDetails(job),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with company logo placeholder and job type badge
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            isExternal ? Colors.blue[400]! : Colors.green[400]!,
                            isExternal ? Colors.blue[600]! : Colors.green[600]!,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isExternal ? Icons.public : Icons.business,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job['title'] ?? 'No Title',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            job['company'] ?? 'Unknown Company',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Match score badge
                    if (matchScore > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: matchScore >= 80
                                ? [Colors.green[400]!, Colors.green[600]!]
                                : matchScore >= 60
                                    ? [Colors.orange[400]!, Colors.orange[600]!]
                                    : [Colors.red[400]!, Colors.red[600]!],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${matchScore.toInt()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Location and salary row
                Row(
                  children: [
                    if (job['location'] != null) ...[
                      Icon(Icons.location_on,
                          size: 16, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          job['location'],
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                    if (job['salary_min'] != null ||
                        job['salary_max'] != null ||
                        job['salary'] != null) ...[
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _formatSalary(job),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 16),

                // Skills section
                if (job['skills'] != null && job['skills'].isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (job['skills'] as List)
                        .take(3)
                        .map((skill) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.blue[200]!),
                              ),
                              child: Text(
                                skill,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (isExternal && job['apply_url'] != null) {
                            _launchUrl(job['apply_url']);
                          } else {
                            _showJobDetails(job);
                          }
                        },
                        icon: Icon(
                          isExternal ? Icons.open_in_new : Icons.visibility,
                          size: 18,
                        ),
                        label: Text(
                          isExternal ? 'Apply Now' : 'View Details',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isExternal ? Colors.blue[600] : Colors.green[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () => _toggleBookmark(job),
                        icon: Icon(
                          _isJobBookmarked(job)
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: _isJobBookmarked(job)
                              ? Colors.blue[600]
                              : Colors.grey[600],
                        ),
                        tooltip: _isJobBookmarked(job)
                            ? 'Remove bookmark'
                            : 'Save job',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatSalary(Map<String, dynamic> job) {
    if (job['salary_min'] != null && job['salary_max'] != null) {
      return '\$${(job['salary_min'] as num).toStringAsFixed(0)} - \$${(job['salary_max'] as num).toStringAsFixed(0)}';
    } else if (job['salary_min'] != null) {
      return '\$${(job['salary_min'] as num).toStringAsFixed(0)}+';
    } else if (job['salary'] != null) {
      return '\$${(job['salary'] as num).toStringAsFixed(0)}';
    }
    return 'Competitive';
  }

  Future<void> _launchUrl(String url) async {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewScreen(
            url: url,
            title: 'External Job',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open $url')),
      );
    }
  }

  void _showJobDetails(Map<String, dynamic>? job) {
    if (job == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job data not available')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobDetailAnalysisScreen(job: job),
      ),
    );
  }

  void _showJobDetailsOld(Map<String, dynamic> job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Builder(
            builder: (context) {
              // Determine if job is external based on source field as per API guide
              final source = job['source']?.toString() ?? '';
              final isExternal = source.isNotEmpty && source != 'Internal';
              final matchScore = (job['match_score'] ?? 0).toDouble();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Enhanced header with close button
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              isExternal
                                  ? Colors.blue[400]!
                                  : Colors.green[400]!,
                              isExternal
                                  ? Colors.blue[600]!
                                  : Colors.green[600]!,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          isExternal ? Icons.public : Icons.business,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job['title'] ?? 'No Title',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              job['company'] ?? 'Unknown Company',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Enhanced metadata cards
                  Row(
                    children: [
                      if (job['location'] != null) ...[
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.location_on,
                                    size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    job['location'],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      if (matchScore > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: matchScore >= 80
                                  ? [Colors.green[400]!, Colors.green[600]!]
                                  : matchScore >= 60
                                      ? [
                                          Colors.orange[400]!,
                                          Colors.orange[600]!
                                        ]
                                      : [Colors.red[400]!, Colors.red[600]!],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${matchScore.toInt()}% Match',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Enhanced job details in scrollable area
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Description section
                          _buildDetailSection(
                            'Job Description',
                            job['description'] ?? 'No description available',
                            Icons.description,
                          ),

                          const SizedBox(height: 24),

                          // Skills section with enhanced styling
                          if (job['skills'] != null &&
                              job['skills'].isNotEmpty) ...[
                            Row(
                              children: [
                                Icon(Icons.psychology, color: Colors.blue[600]),
                                const SizedBox(width: 8),
                                const Text(
                                  'Required Skills',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _showCoursesForSkills(job['skills']);
                                  },
                                  icon: const Icon(Icons.school, size: 16),
                                  label: const Text('View Courses'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.blue[600],
                                    backgroundColor: Colors.blue[50],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: (job['skills'] as List)
                                  .map((skill) => InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.pushNamed(
                                            context,
                                            AppRoutes.coursesRoute,
                                            arguments: {"skill": skill},
                                          );
                                        },
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.blue[50],
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: Colors.blue[200]!),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                skill,
                                                style: TextStyle(
                                                  color: Colors.blue[700],
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                size: 12,
                                                color: Colors.blue[600],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Salary information with enhanced styling
                          if (job['salary_min'] != null ||
                              job['salary_max'] != null ||
                              job['salary'] != null) ...[
                            _buildDetailSection(
                              'Salary Range',
                              _formatSalary(job),
                              Icons.attach_money,
                              isHighlight: true,
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Expiry date with urgency indicator
                          if (job['expiry'] != null) ...[
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red[200]!),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.schedule, color: Colors.red[600]),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Application Deadline',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red[700],
                                          ),
                                        ),
                                        Text(
                                          'Due ${job['expiry']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.red[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Enhanced action buttons with better spacing and styling
                  Column(
                    children: [
                      Row(
                        children: [
                          // Enhanced bookmark button
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _isJobBookmarked(job)
                                      ? Colors.blue[300]!
                                      : Colors.grey[300]!,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextButton.icon(
                                onPressed: () => _toggleBookmark(job),
                                icon: Icon(
                                  _isJobBookmarked(job)
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  size: 20,
                                ),
                                label: Text(
                                    _isJobBookmarked(job) ? 'Saved' : 'Save'),
                                style: TextButton.styleFrom(
                                  foregroundColor: _isJobBookmarked(job)
                                      ? Colors.blue[600]
                                      : Colors.grey[700],
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Enhanced share button
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextButton.icon(
                                onPressed: () => _shareJob(job),
                                icon: const Icon(Icons.share, size: 20),
                                label: const Text('Share'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey[700],
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Enhanced apply button with gradient
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isExternal
                                  ? [Colors.blue[400]!, Colors.blue[600]!]
                                  : [Colors.green[400]!, Colors.green[600]!],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: (isExternal ? Colors.blue : Colors.green)
                                    .withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              if (isExternal) {
                                _launchUrl(job['apply_url']);
                              } else {
                                _applyForInternalJob(job);
                              }
                            },
                            icon: Icon(
                              isExternal ? Icons.open_in_new : Icons.send,
                              size: 20,
                            ),
                            label: Text(
                              isExternal ? 'Apply' : 'Submit Application',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content, IconData icon,
      {bool isHighlight = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlight ? Colors.green[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: isHighlight ? Border.all(color: Colors.green[200]!) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: isHighlight ? Colors.green[600] : Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isHighlight ? Colors.green[700] : Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: isHighlight ? 18 : 15,
              fontWeight: isHighlight ? FontWeight.w600 : FontWeight.normal,
              color: isHighlight ? Colors.green[700] : Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _applyForInternalJob(Map<String, dynamic> job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.work, color: Colors.green[600]),
            ),
            const SizedBox(width: 12),
            const Expanded(child: Text('Apply for Job')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Position: ${job['title']}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your application will be submitted with your current profile and CV.',
              style: TextStyle(height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Application submitted successfully!'),
                    ],
                  ),
                  backgroundColor: Colors.green[600],
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.send),
            label: const Text('Submit Application'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showJobFilters() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.tune, color: Colors.blue[600]),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Filter Jobs',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildFilterOption(
              Icons.business,
              'Internal Jobs Only',
              'Jobs within your organization',
              Colors.green,
              () {
                Navigator.pop(context);
                setState(() {
                  filteredJobs = allJobs
                      .where((job) =>
                          (job['source']?.toString() ?? '').isEmpty ||
                          job['source'] == 'Internal')
                      .toList();
                });
              },
            ),
            _buildFilterOption(
              Icons.public,
              'External Jobs Only',
              'Jobs from external companies',
              Colors.blue,
              () {
                Navigator.pop(context);
                setState(() {
                  filteredJobs = allJobs
                      .where((job) =>
                          (job['source']?.toString() ?? '').isNotEmpty &&
                          job['source'] != 'Internal')
                      .toList();
                });
              },
            ),
            _buildFilterOption(
              Icons.star,
              'High Match Score (80%+)',
              'Jobs that closely match your skills',
              Colors.orange,
              () {
                Navigator.pop(context);
                setState(() {
                  filteredJobs = allJobs.where((job) {
                    final matchScore = job['match_score'];
                    if (matchScore == null) return false;

                    double score = 0.0;
                    if (matchScore is int) {
                      score = matchScore.toDouble();
                    } else if (matchScore is double) {
                      score = matchScore;
                    } else if (matchScore is String) {
                      score = double.tryParse(matchScore) ?? 0.0;
                    }

                    return score >= 80.0;
                  }).toList();
                });
              },
            ),
            _buildFilterOption(
              Icons.clear,
              'Clear All Filters',
              'Show all available jobs',
              Colors.grey,
              () {
                Navigator.pop(context);
                setState(() {
                  filteredJobs = allJobs;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(
    IconData icon,
    String title,
    String subtitle,
    MaterialColor color,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        dense: true,
        visualDensity: const VisualDensity(vertical: -2),
        minLeadingWidth: 0,
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color[600]),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        trailing:
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showAllJobs() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.work_outline, color: Colors.blue[600]),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'All Job Recommendations',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                itemCount: filteredJobs.length,
                itemBuilder: (context, index) {
                  final job = filteredJobs[index];
                  return _buildEnhancedJobCard(
                      job, Theme.of(context).textTheme, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bookmark functionality
  Set<int> bookmarkedJobs = {};

  bool _isJobBookmarked(Map<String, dynamic> job) {
    final jobId = job['id'];
    return jobId != null && bookmarkedJobs.contains(jobId);
  }

  void _toggleBookmark(Map<String, dynamic> job) async {
    final jobId = job['id'];
    if (jobId == null) return;

    try {
      final jobProv = ref.read(jobProvider);

      if (_isJobBookmarked(job)) {
        final success = await jobProv.removeBookmark(id: jobId);
        if (success) {
          setState(() {
            bookmarkedJobs.remove(jobId);
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.bookmark_remove, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Job removed from bookmarks'),
                  ],
                ),
                backgroundColor: Colors.orange[600],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        }
      } else {
        final success = await jobProv.addBookmark(id: jobId);
        if (success) {
          setState(() {
            bookmarkedJobs.add(jobId);
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.bookmark_added, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Job saved to bookmarks'),
                  ],
                ),
                backgroundColor: Colors.green[600],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  void _shareJob(Map<String, dynamic> job) async {
    try {
      final jobTitle = job['title'] ?? 'Job Opportunity';
      final company = job['company'] ?? 'Company';
      final location = job['location'] ?? 'Location';
      final source = job['source']?.toString() ?? '';
      final isExternal = source.isNotEmpty && source != 'Internal';

      String shareText = '$jobTitle at $company\n';
      shareText += 'Location: $location\n';

      if (job['salary_min'] != null || job['salary_max'] != null) {
        shareText += 'Salary: ${_formatSalary(job)}\n';
      }

      if (isExternal && job['apply_url'] != null) {
        shareText += '\nApply here: ${job['apply_url']}';
      } else {
        shareText += '\nFound on Skill Sage - Your Career Growth Platform';
      }

      await Share.share(
        shareText,
        subject: '$jobTitle - Job Opportunity',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing job: $e'),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  void _showCoursesForSkills(List skills) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[50]!, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                        Icon(Icons.school, color: Colors.blue[600], size: 24),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Learn Required Skills',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: skills.length,
                itemBuilder: (context, index) {
                  final skill = skills[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            AppRoutes.coursesRoute,
                            arguments: {"skill": skill},
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue[400]!,
                                      Colors.blue[600]!
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.psychology,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      skill,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Explore courses and learning paths',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.blue[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsAnalysisSection() {
    // Get skills from recommendation provider
    final recommenderProv = ref.watch(recommenderProvider);

    if (recommenderProv.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (recommenderProv.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Error loading skills: ${recommenderProv.error}',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    final matchedSkills = recommenderProv.userSkills;
    final missingSkills = recommenderProv.missingSkills;

    if (matchedSkills.isEmpty && missingSkills.isEmpty) {
      return const SizedBox.shrink();
    }

    return SkillsAnalysisSection(
      matchedSkills: matchedSkills,
      missingSkills: missingSkills,
      onSkillTap: (skill) {
        Navigator.pushNamed(
          context,
          AppRoutes.coursesRoute,
          arguments: {"skill": skill},
        );
      },
      onLearnSkill: (skill) {
        Navigator.pushNamed(
          context,
          AppRoutes.youtubeVideosRoute,
          arguments: {"skill": skill},
        );
      },
    );
  }
}
