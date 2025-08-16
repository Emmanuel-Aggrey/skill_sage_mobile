part of '_index.dart';

class ExternalJobsScreen extends ConsumerStatefulWidget {
  const ExternalJobsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ExternalJobsScreen> createState() => _ExternalJobsScreenState();
}

class _ExternalJobsScreenState extends ConsumerState<ExternalJobsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? selectedSource;
  bool isLoading = false;

  final List<String> jobSources = [
    'StackOverflow',
    'We Work Remotely',
    'Remote OK',
    'Greenhouse'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    try {
      final jobProv = ref.read(jobProvider);
      await jobProv.loadExternalJobs(source: selectedSource);
      await jobProv.loadAllRecommendedJobs();
    } catch (e) {
      _showSnackBar('Failed to load jobs: $e');
    }
    setState(() => isLoading = false);
  }

  Future<void> _scrapeJobs() async {
    setState(() => isLoading = true);
    try {
      final jobProv = ref.read(jobProvider);
      await jobProv.scrapeExternalJobs();
      await _loadData();
      _showSnackBar('Successfully scraped new jobs!');
    } catch (e) {
      _showSnackBar('Failed to scrape jobs: $e');
    }
    setState(() => isLoading = false);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _launchUrl(String url) async {
    // For now, show a dialog with the URL
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('External Job'),
        content: Text('This will open: $url'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('URL copied to clipboard (feature coming soon)');
            },
            child: const Text('Open'),
          ),
        ],
      ),
    );
  }

  Color _getSourceColor(String source) {
    switch (source) {
      case 'StackOverflow':
        return Colors.orange;
      case 'We Work Remotely':
        return Colors.green;
      case 'Remote OK':
        return Colors.blue;
      case 'Greenhouse':
        return Colors.purple;
      case 'Internal':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  Widget _buildJobCard(Map<String, dynamic> job,
      {bool showMatchScore = false}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job['title'] ?? 'No Title',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job['company'] ?? 'Unknown Company',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getSourceColor(job['source'] ?? 'Unknown'),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    job['source'] ?? 'Unknown',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (job['location'] != null)
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(job['location']),
                ],
              ),
            const SizedBox(height: 8),
            if (job['skills'] != null && job['skills'].isNotEmpty)
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: (job['skills'] as List)
                    .take(5)
                    .map((skill) => Chip(
                          label: Text(
                            skill,
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: Colors.blue[50],
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ))
                    .toList(),
              ),
            const SizedBox(height: 8),
            if (showMatchScore && job['match_score'] != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: job['match_score'] >= 80
                      ? Colors.green
                      : job['match_score'] >= 60
                          ? Colors.orange
                          : Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Match: ${job['match_score']}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (job['salary_min'] != null || job['salary_max'] != null)
                  Text(
                    _formatSalary(job),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  )
                else
                  const SizedBox(),
                ElevatedButton.icon(
                  onPressed: () {
                    if (job['apply_url'] != null) {
                      _launchUrl(job['apply_url']);
                    } else {
                      _showSnackBar('This is an internal job posting');
                    }
                  },
                  icon: Icon(job['is_external'] == true
                      ? Icons.open_in_new
                      : Icons.visibility),
                  label: Text(job['is_external'] == true ? 'Apply' : 'View'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
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
    return 'Salary not specified';
  }

  @override
  Widget build(BuildContext context) {
    final jobProv = ref.watch(jobProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('External Jobs'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _scrapeJobs,
            icon: const Icon(Icons.refresh),
            tooltip: 'Scrape New Jobs',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                selectedSource = value == 'All' ? null : value;
              });
              _loadData();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'All', child: Text('All Sources')),
              ...jobSources.map((source) => PopupMenuItem(
                    value: source,
                    child: Text(source),
                  )),
            ],
            child: const Icon(Icons.filter_list),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'All Jobs (${jobProv.externalJobs.length})'),
            Tab(text: 'Recommended (${jobProv.allRecommendedJobs.length})'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                // All External Jobs Tab
                RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.builder(
                    itemCount: jobProv.externalJobs.length,
                    itemBuilder: (context, index) {
                      final job = jobProv.externalJobs[index];
                      return _buildJobCard(job);
                    },
                  ),
                ),

                // Recommended Jobs Tab
                RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.builder(
                    itemCount: jobProv.allRecommendedJobs.length,
                    itemBuilder: (context, index) {
                      final job = jobProv.allRecommendedJobs[index];
                      return _buildJobCard(job, showMatchScore: true);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
