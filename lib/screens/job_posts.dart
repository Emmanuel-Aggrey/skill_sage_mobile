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
      showToast(context, 'added');
    }
  }

  Future<void> apply(WidgetRef ref, int id, BuildContext context) async {
    final resp = await ref.read(jobProvider).addApplication(id: id);
    if (resp) {
      showToast(context, 'added');
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
          // Container(
          //   width: double.infinity,
          //   color: appTheme.scaffold,
          //   child: ListTile(
          //     title: Center(
          //       child: Text(
          //         "Job Posts",
          //         style: textTheme.headlineMedium,
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(
            height: 20.0,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: CupertinoSearchTextField(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: appTheme.scaffold,
              ),
              style: textTheme.titleSmall,
              placeholder: "Search jobs...",
              onChanged: _filterJobs,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadJobs,
              child: filteredJobs.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/not_found.png",
                              height: 100),
                          const SizedBox(height: 10),
                          Text(
                            searchQuery.isEmpty
                                ? "No jobs available"
                                : "No jobs found for '$searchQuery'",
                            style: textTheme.labelSmall,
                          ),
                          TextButton(
                            onPressed: _loadJobs,
                            child: const Text("Reload"),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredJobs.length,
                      itemBuilder: (context, index) {
                        final job = filteredJobs[index];
                        return GestureDetector(
                          onTap: () => showModalBottomSheet(
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
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildModal(size, appTheme, textTheme, data, ref, context, user) {
    return Container(
      height: size.height,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
        color: appTheme.scaffold,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(data['title'], style: textTheme.headlineMedium),
            const SizedBox(height: 10),
            ListTile(
              minLeadingWidth: 0,
              contentPadding: EdgeInsets.zero,
              leading: Container(
                height: 60,
                width: 60,
                // padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: appTheme.primary,
                  ),
                  image: (data['image'] == null)
                      ? const DecorationImage(
                          image: AssetImage('assets/images/default.jpg'),
                          fit: BoxFit.cover,
                        )
                      : DecorationImage(
                          image: NetworkImage(data['image']),
                          fit: BoxFit.cover,
                        ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              title: Text("Posted by", style: textTheme.labelMedium),
              subtitle: Text("Fintech", style: textTheme.bodySmall),
              trailing:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text("Expiry Date", style: textTheme.labelMedium),
                Text(data['expiry'], style: textTheme.bodySmall),
                const SizedBox(height: 10),
                Text("Ghc${data['salary']}/year",
                    style: textTheme.headlineMedium)
              ]),
            ),
            const SizedBox(height: 10),
            Text(data['location'], style: textTheme.headlineMedium),
            const SizedBox(height: 20),
            SizedBox(
              height: size.height * .25,
              child: ListView(shrinkWrap: true, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Job Description", style: textTheme.headlineMedium),
                  const SizedBox(height: 10),
                  Text(
                    data['description'],
                    style: textTheme.bodySmall,
                  )
                ]),
                const SizedBox(height: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    children: [
                      Text("Requirements", style: textTheme.headlineMedium),
                      const Spacer(),
                      if (data['skills'] != null && data['skills'].isNotEmpty)
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _showCoursesForSkills(context, data['skills']);
                          },
                          icon: const Icon(Icons.school, size: 16),
                          label: const Text('View Courses'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  for (int i = 0; i < data['requirements'].length; i++)
                    Text(
                      data['requirements'][i],
                      style: textTheme.bodySmall,
                    )
                ]),
              ]),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                height: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width * .4,
                      child: ElevatedButton(
                          onPressed: () {
                            if (user.resume.isEmpty &&
                                user.experience.isEmpty &&
                                user.education.isEmpty) {
                              showToast(context,
                                  "Upload Resume or Update your Profile");
                            } else {
                              apply(ref, data['id'], context);
                            }
                            Navigator.pop(context);
                          },
                          child: const Text("Apply")),
                    ),
                    SizedBox(
                      width: size.width * .4,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(
                              color: appTheme.txt,
                            ),
                          ),
                        ),
                        onPressed: () {
                          add(ref, data['id'], context);
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Save",
                          style: textTheme.bodySmall,
                        ),
                      ),
                    ),
                    // CustomButton(title: 'Save'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCoursesForSkills(BuildContext context, List skills) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Text(
                    'Learn Required Skills',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: skills.length,
                itemBuilder: (context, index) {
                  final skill = skills[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.school,
                          color: Colors.blue,
                        ),
                      ),
                      title: Text(
                        skill,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: const Text('Tap to view available courses'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          AppRoutes.coursesRoute,
                          arguments: {"skill": skill},
                        );
                      },
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
}
