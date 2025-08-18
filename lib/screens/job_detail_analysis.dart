part of '_index.dart';

class JobDetailAnalysisScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> job;

  const JobDetailAnalysisScreen({
    super.key,
    required this.job,
  });

  @override
  ConsumerState<JobDetailAnalysisScreen> createState() =>
      _JobDetailAnalysisScreenState();
}

class _JobDetailAnalysisScreenState
    extends ConsumerState<JobDetailAnalysisScreen> {
  Map<String, dynamic>? detailedAnalysis;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadDetailedAnalysis();
  }

  Future<void> _loadDetailedAnalysis() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final jobProv = ref.read(jobProvider);
      final jobId = widget.job['id'] as int;
      final rawSource = widget.job['source'] as String?;

      final source = (rawSource == null || rawSource.trim().isEmpty)
          ? 'job'
          : "external_job";

      final response = await jobProv.getDetailedMatchAnalysis(
        source,
        jobId,
        includeImprovementPlan: true,
        includeSimilarItems: true,
        forceRefresh: false,
      );

      setState(() {
        detailedAnalysis = response.result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Failed to load detailed analysis: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = CustomTextTheme.customTextTheme(context).textTheme;
    final source = widget.job['source']?.toString() ?? '';
    final isExternal = source.isNotEmpty && source != 'Internal';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.job['title'] ?? 'Job Details',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _shareJob(),
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? _buildErrorState()
              : _buildContent(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text(
            error!,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadDetailedAnalysis,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final textTheme = CustomTextTheme.customTextTheme(context).textTheme;

    // Make sure we're accessing the correct data structure
    final analysis = detailedAnalysis!;
    print('Analysis keys: ${analysis.keys}'); // Debug print

    final item = analysis['item'] as Map<String, dynamic>? ?? {};
    final matchAnalysis =
        analysis['match_analysis'] as Map<String, dynamic>? ?? {};
    final improvementPlan =
        analysis['improvement_plan'] as Map<String, dynamic>? ?? {};
    final userProfile =
        analysis['user_profile_summary'] as Map<String, dynamic>? ?? {};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Job Header Card
          _buildJobHeaderCard(item, matchAnalysis),

          const SizedBox(height: 16),

          // Match Analysis Card
          _buildMatchAnalysisCard(matchAnalysis),

          const SizedBox(height: 16),

          // Skills Analysis
          _buildSkillsAnalysisCard(matchAnalysis),

          // Only show improvement plan if it exists and has content
          if (improvementPlan != null &&
              (improvementPlan['improvement_steps'] != null ||
                  improvementPlan['resources'] != null)) ...[
            const SizedBox(height: 16),
            _buildImprovementPlanCard(improvementPlan),
          ],

          const SizedBox(height: 16),

          // User Profile Summary
          _buildUserProfileCard(userProfile),

          const SizedBox(height: 16),

          // Action Buttons
          _buildActionButtons(),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildJobHeaderCard(
      Map<String, dynamic> item, Map<String, dynamic> matchAnalysis) {
    final textTheme = CustomTextTheme.customTextTheme(context).textTheme;
    final source = widget.job['source']?.toString() ?? '';
    final isExternal = source.isNotEmpty && source != 'Internal';
    final overallScore = (matchAnalysis['overall_score'] ?? 0).toDouble();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        isExternal ? Colors.blue[400]! : Colors.green[400]!,
                        isExternal ? Colors.blue[600]! : Colors.green[600]!,
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
                        item['title'] ?? 'No Title',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['company'] ?? 'Unknown Company',
                        style: textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: overallScore >= 80
                          ? [Colors.green[400]!, Colors.green[600]!]
                          : overallScore >= 60
                              ? [Colors.orange[400]!, Colors.orange[600]!]
                              : [Colors.red[400]!, Colors.red[600]!],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${overallScore.toInt()}% Match',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (item['location'] != null) ...[
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    item['location'],
                    style:
                        textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            if (item['salary'] != null) ...[
              Row(
                children: [
                  Icon(Icons.attach_money, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    '\$${item['salary']}',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            if (item['description'] != null) ...[
              const SizedBox(height: 8),
              Text(
                'Description',
                style: textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                item['description'],
                style: textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMatchAnalysisCard(Map<String, dynamic> matchAnalysis) {
    final textTheme = CustomTextTheme.customTextTheme(context).textTheme;
    final overallScore = (matchAnalysis['overall_score'] ?? 0).toDouble();
    final skillCompatibility =
        (matchAnalysis['skill_compatibility'] ?? 0).toDouble();
    final skillGapCount = matchAnalysis['skill_gap_count'] ?? 0;
    final readinessAssessment = matchAnalysis['readiness_assessment'] ?? '';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: Colors.blue[600]),
                const SizedBox(width: 8),
                Text(
                  'Match Analysis',
                  style: textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildScoreCard(
                    'Overall Score',
                    '${overallScore.toInt()}%',
                    overallScore,
                    Icons.star,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildScoreCard(
                    'Skill Match',
                    '${skillCompatibility.toInt()}%',
                    skillCompatibility,
                    Icons.psychology,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.assessment, color: Colors.blue[600], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Readiness Assessment',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    readinessAssessment,
                    style:
                        textTheme.bodyMedium?.copyWith(color: Colors.blue[700]),
                  ),
                  if (skillGapCount > 0) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Skills to develop: $skillGapCount',
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.orange[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(
      String title, String score, double value, IconData icon) {
    final textTheme = CustomTextTheme.customTextTheme(context).textTheme;
    final color = value >= 80
        ? Colors.green
        : value >= 60
            ? Colors.orange
            : Colors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: color[600], size: 24),
          const SizedBox(height: 8),
          Text(
            score,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color[700],
            ),
          ),
          Text(
            title,
            style: textTheme.bodySmall?.copyWith(color: color[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsAnalysisCard(Map<String, dynamic> matchAnalysis) {
    final textTheme = CustomTextTheme.customTextTheme(context).textTheme;
    final matchedSkills =
        matchAnalysis['matched_skills'] as List<dynamic>? ?? [];
    final missingSkills =
        matchAnalysis['missing_skills'] as List<dynamic>? ?? [];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: Colors.purple[600]),
                const SizedBox(width: 8),
                Text(
                  'Skills Analysis',
                  style: textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (matchedSkills.isNotEmpty) ...[
              _buildSkillsSection(
                'Matched Skills',
                matchedSkills.cast<String>(),
                Colors.green,
                Icons.check_circle,
              ),
              const SizedBox(height: 16),
            ],
            if (missingSkills.isNotEmpty) ...[
              _buildSkillsSection(
                'Skills to Learn',
                missingSkills.cast<String>(),
                Colors.orange,
                Icons.school,
                showLearnButton: true,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsSection(
    String title,
    List<String> skills,
    MaterialColor color,
    IconData icon, {
    bool showLearnButton = false,
  }) {
    final textTheme = CustomTextTheme.customTextTheme(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color[600], size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color[700],
              ),
            ),
            const Spacer(),
            if (showLearnButton)
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.youtubeVideosRoute,
                    arguments: {"skills": skills},
                  );
                  print('skills : $skills');
                  // print(skills)
                },
                icon: const Icon(Icons.play_arrow, size: 16),
                label: const Text('Learn All'),
                style: TextButton.styleFrom(
                  foregroundColor: color[600],
                  backgroundColor: color[50],
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills
              .map((skill) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: color[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color[200]!),
                    ),
                    child: Text(
                      skill,
                      style: TextStyle(
                        fontSize: 14,
                        color: color[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Map<String, dynamic> _parseStepString(String stepString) {
    try {
      // Try to parse as JSON first
      if (stepString.startsWith('{') && stepString.endsWith('}')) {
        return json.decode(stepString) as Map<String, dynamic>;
      }

      // If not JSON, parse manually using regex or string manipulation
      final Map<String, dynamic> parsed = {};

      // Extract step_number
      final stepNumMatch =
          RegExp(r'step_number:\s*(\d+)').firstMatch(stepString);
      if (stepNumMatch != null) {
        parsed['step_number'] = int.tryParse(stepNumMatch.group(1)!) ?? 0;
      }

      // Extract title
      final titleMatch = RegExp(r'title:\s*([^,}]+)').firstMatch(stepString);
      if (titleMatch != null) {
        parsed['title'] = titleMatch.group(1)!.trim();
      }

      // Extract description
      final descMatch = RegExp(
              r'description:\s*([^,}]+(?:,[^{}]*?)?)(?=,\s*estimated_duration|$)')
          .firstMatch(stepString);
      if (descMatch != null) {
        parsed['description'] = descMatch.group(1)!.trim();
      }

      // Extract estimated_duration
      final durationMatch =
          RegExp(r'estimated_duration:\s*([^,}]+)').firstMatch(stepString);
      if (durationMatch != null) {
        parsed['estimated_duration'] = durationMatch.group(1)!.trim();
      }

      // Extract resources (everything after resources:)
      final resourcesMatch =
          RegExp(r'resources:\s*\[([^\]]*)\]').firstMatch(stepString);
      if (resourcesMatch != null) {
        final resourcesStr = resourcesMatch.group(1)!;
        parsed['resources'] =
            resourcesStr.split(',').map((e) => e.trim()).toList();
      }

      return parsed;
    } catch (e) {
      print('Error parsing step: $e');
      return {'raw_text': stepString};
    }
  }

  Widget _buildImprovementPlanCard(Map<String, dynamic> improvementPlan) {
    final textTheme = CustomTextTheme.customTextTheme(context).textTheme;

    final rawSteps =
        (improvementPlan['improvement_steps'] as List<dynamic>?) ?? [];
    final estimatedTime = improvementPlan['estimated_time']?.toString() ?? '';
    final resources = (improvementPlan['resources'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    // Parse the step strings into structured data
    final parsedSteps = rawSteps.map((step) {
      if (step is String) {
        return _parseStepString(step);
      }
      return step as Map<String, dynamic>? ?? {};
    }).toList();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: Colors.indigo[600]),
                const SizedBox(width: 8),
                Text(
                  'Improvement Plan',
                  style: textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (estimatedTime.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.indigo[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      estimatedTime,
                      style: TextStyle(
                        color: Colors.indigo[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (parsedSteps.isNotEmpty) ...[
              Text(
                'Learning Steps',
                style: textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...parsedSteps
                  .map((step) => _buildParsedImprovementStep(step))
                  .toList(),
              const SizedBox(height: 16),
            ],
            if (resources.isNotEmpty) ...[
              Text(
                'Recommended Resources',
                style: textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...resources
                  .map((resource) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.link,
                                  size: 16, color: Colors.blue[600]),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  resource,
                                  style: textTheme.bodySmall
                                      ?.copyWith(color: Colors.blue[700]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRawTextStep(String rawText) {
    final textTheme = CustomTextTheme.customTextTheme(context).textTheme;

    // Try to extract at least the step number from the beginning
    final stepMatch = RegExp(r'^(\d+)').firstMatch(rawText);
    final stepNumber = stepMatch?.group(1) ?? '•';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.indigo[600],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                stepNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              rawText,
              style: textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParsedImprovementStep(Map<String, dynamic> step) {
    final textTheme = CustomTextTheme.customTextTheme(context).textTheme;

    // Handle both parsed and raw text
    if (step.containsKey('raw_text')) {
      return _buildRawTextStep(step['raw_text'] as String);
    }

    final stepNumber = step['step_number'] ?? 0;
    final title = step['title']?.toString() ?? 'Learning Step';
    final description = step['description']?.toString() ?? '';
    final duration = step['estimated_duration']?.toString() ?? '';
    final stepResources = (step['resources'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.indigo[600],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    stepNumber.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (duration.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          duration,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              description,
              style: textTheme.bodyMedium,
            ),
          ],
          if (stepResources.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Resources for this step:',
              style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            ...stepResources
                .map((resource) => Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.link, size: 14, color: Colors.blue[600]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              resource,
                              style: textTheme.bodySmall
                                  ?.copyWith(color: Colors.blue[600]),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildSimpleImprovementStep(int stepNumber, String stepText) {
    final textTheme = CustomTextTheme.customTextTheme(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.indigo[600],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                stepNumber.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              stepText,
              style: textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImprovementStep(Map<String, dynamic> step) {
    final textTheme = CustomTextTheme.customTextTheme(context).textTheme;
    final stepNumber = step['step_number'] ?? 0;
    final title = step['title'] ?? '';
    final description = step['description'] ?? '';
    final duration = step['estimated_duration'] ?? '';
    final actions = step['actions'] as List<dynamic>? ?? [];
    final resources = step['resources'] as List<dynamic>? ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.indigo[600],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    stepNumber.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              if (duration.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    duration,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              description,
              style: textTheme.bodyMedium,
            ),
          ],
          if (actions.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Actions:',
              style:
                  textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            ...actions
                .map((action) => Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• ', style: textTheme.bodyMedium),
                          Expanded(
                            child: Text(
                              action.toString(),
                              style: textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
          if (resources.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Resources:',
              style:
                  textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            ...resources
                .map((resource) => Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• ', style: textTheme.bodyMedium),
                          Expanded(
                            child: Text(
                              resource.toString(),
                              style: textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildUserProfileCard(Map<String, dynamic> userProfile) {
    final textTheme = CustomTextTheme.customTextTheme(context).textTheme;
    final totalSkills = userProfile['total_skills'] ?? 0;
    final experienceLevel = userProfile['experience_level'] ?? 'Not specified';
    final profileStrength = userProfile['profile_strength'] ?? 'Unknown';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.teal[600]),
                const SizedBox(width: 8),
                Text(
                  'Your Profile Summary',
                  style: textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildProfileStat(
                      'Total Skills', totalSkills.toString(), Icons.psychology),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildProfileStat(
                      'Experience', experienceLevel, Icons.work),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildProfileStat(
                      'Profile Strength', profileStrength, Icons.star),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat(String title, String value, IconData icon) {
    final textTheme = CustomTextTheme.customTextTheme(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.teal[600], size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.teal[700],
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            title,
            style: textTheme.bodySmall?.copyWith(color: Colors.teal[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final source = widget.job['source']?.toString() ?? '';
    final isExternal = source.isNotEmpty && source != 'Internal';

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _shareJob(),
                icon: const Icon(Icons.share),
                label: const Text('Share Analysis'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _bookmarkJob(),
                icon: const Icon(Icons.bookmark_border),
                label: const Text('Save Job'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _applyForJob(),
            icon: Icon(isExternal ? Icons.open_in_new : Icons.send),
            label: Text(isExternal ? 'Apply Externally' : 'Submit Application'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isExternal ? Colors.blue[600] : Colors.green[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _shareJob() {
    // Implement job sharing functionality using share_plus
    final jobTitle = widget.job['title'] ?? 'Job Opportunity';
    final company = widget.job['company'] ?? 'Company';

    Share.share(
      'Check out this job opportunity: $jobTitle at $company',
      subject: 'Job Recommendation',
    );
  }

  void _bookmarkJob() {
    // Implement bookmark functionality
    final jobProv = ref.read(jobProvider);
    final jobId = widget.job['id'];
    jobProv.addBookmark(id: jobId);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Job saved to bookmarks')),
    );
  }

  void _applyForJob() {
    final source = widget.job['source']?.toString() ?? '';
    final isExternal = source.isNotEmpty && source != 'Internal';

    if (isExternal && widget.job['apply_url'] != null) {
      // Open external URL
      launchUrl(Uri.parse(widget.job['apply_url']));
    } else {
      // Handle internal application
      final jobProv = ref.read(jobProvider);
      final jobId = widget.job['id'];
      jobProv.addApplication(id: jobId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application submitted successfully')),
      );
    }
  }
}
