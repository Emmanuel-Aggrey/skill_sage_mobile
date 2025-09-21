part of '_index.dart';

class JobPostScreen extends ConsumerStatefulWidget {
  const JobPostScreen({super.key});

  @override
  ConsumerState<JobPostScreen> createState() => _JobPostScreenState();
}

class _JobPostScreenState extends ConsumerState<JobPostScreen> {
  String searchQuery = "";
  List<dynamic> allJobs = [];
  List<dynamic> filteredJobs = [];

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    try {
      final jobProv = ref.read(jobProvider);
      final resp = await jobProv.loadJobs();
      setState(() {
        allJobs = resp.result ?? [];
        filteredJobs = allJobs;
        print("all jobs");
        print(allJobs);
      });
    } catch (e) {
      print('Error loading jobs: $e');
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

  Future<void> add(WidgetRef ref, int id, BuildContext context) async {
    final resp = await ref.read(jobProvider).addBookmark(id: id);
    if (resp) {
      showToast(context, 'Job saved');
    }
  }

  Future<void> apply(WidgetRef ref, int id, BuildContext context) async {
    final resp = await ref.read(jobProvider).addApplication(id: id);
    if (resp) {
      showToast(context, 'Application sent');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = CustomTextTheme.customTextTheme(context).textTheme;
    final appTheme = AppTheme.appTheme(context);

    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: CupertinoSearchTextField(
              padding: const EdgeInsets.all(12),
              prefixInsets: const EdgeInsets.only(left: 12),
              suffixInsets: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: appTheme.scaffold,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              style: textTheme.titleSmall,
              placeholder: "Search jobs by title, company, or skill...",
              onChanged: _filterJobs,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadJobs,
              child: filteredJobs.isEmpty
                  ? _buildEmptyState(textTheme)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      itemCount: filteredJobs.length,
                      itemBuilder: (context, index) {
                        final job = filteredJobs[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      JobDetailAnalysisScreen(job: job),
                                ),
                              );
                            },
                            child: JobCard(
                              title: job['title'],
                              company: job['company'] ?? 'Company',
                              location: job['location'],
                              datePosted: "Due ${job['expiry']}",
                              skills: job['skills'],
                              img: job['image'],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/not_found.png", height: 140),
          const SizedBox(height: 16),
          Text(
            searchQuery.isEmpty
                ? "No jobs available at the moment"
                : "No results for '$searchQuery'",
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _loadJobs,
            icon: const Icon(Icons.refresh),
            label: const Text("Reload"),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
