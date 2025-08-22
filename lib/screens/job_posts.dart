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
    final size = MediaQuery.of(context).size;
    final user = ref.watch(userProvider).user;

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
                            onTap: () => showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) => _buildModal(size, appTheme,
                                  textTheme, job, ref, context, user),
                            ),
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

  Widget _buildModal(size, appTheme, textTheme, data, ref, context, user) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: appTheme.scaffold,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        builder: (_, controller) => SingleChildScrollView(
          controller: controller,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 5,
                  width: 50,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(data['title'], style: textTheme.headlineMedium),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on, color: appTheme.primary, size: 18),
                  const SizedBox(width: 6),
                  Text(data['location'], style: textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: 20),
              _buildSection("Job Description", data['description'], textTheme),
              const SizedBox(height: 16),
              _buildSection("Requirements",
                  (data['requirements'] as List).join("\n• "), textTheme),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (user.resume.isEmpty &&
                            user.experience.isEmpty &&
                            user.education.isEmpty) {
                          showToast(
                              context, "Upload Resume or Update your Profile");
                        } else {
                          apply(ref, data['id'], context);
                        }
                        Navigator.pop(context);
                      },
                      label: const Text("Apply Now"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.bookmark_border),
                      onPressed: () {
                        add(ref, data['id'], context);
                        Navigator.pop(context);
                      },
                      label: const Text("Save"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.label, size: 18, color: Colors.grey[600]),
            const SizedBox(width: 6),
            Text(title, style: textTheme.headlineSmall),
          ],
        ),
        const SizedBox(height: 8),
        Text(content, style: textTheme.bodySmall),
      ],
    );
  }
}
