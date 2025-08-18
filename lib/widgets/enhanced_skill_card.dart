part of '_index.dart';

class EnhancedSkillCard extends StatelessWidget {
  final String skillName;
  final String skillType; // 'matched' or 'missing'
  final String? level;
  final VoidCallback? onTap;
  final VoidCallback? onLearnPressed;
  final bool showLearnButton;

  const EnhancedSkillCard({
    super.key,
    required this.skillName,
    required this.skillType,
    this.level,
    this.onTap,
    this.onLearnPressed,
    this.showLearnButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = CustomTextTheme.customTextTheme(context).textTheme;
    final isMatched = skillType == 'matched';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with skill type indicator
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isMatched ? Colors.green[50] : Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isMatched ? Icons.check_circle : Icons.school,
                        color:
                            isMatched ? Colors.green[600] : Colors.orange[600],
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            skillName,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (level != null) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isMatched
                                    ? Colors.green[100]
                                    : Colors.orange[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                level!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isMatched
                                      ? Colors.green[700]
                                      : Colors.orange[700],
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

                const SizedBox(height: 12),

                // Status text
                Text(
                  isMatched ? 'You have this skill' : 'Skill gap identified',
                  style: textTheme.bodySmall?.copyWith(
                    color: isMatched ? Colors.green[600] : Colors.orange[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),

                // Learn button for missing skills
                if (!isMatched && showLearnButton) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onLearnPressed,
                      icon: const Icon(Icons.play_arrow, size: 18),
                      label: const Text(
                        'Learn Skill',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SkillsAnalysisSection extends StatefulWidget {
  final List<String> matchedSkills;
  final List<String> missingSkills;
  final Function(String skill) onSkillTap;
  final Function(String skill) onLearnSkill;

  const SkillsAnalysisSection({
    super.key,
    required this.matchedSkills,
    required this.missingSkills,
    required this.onSkillTap,
    required this.onLearnSkill,
  });

  @override
  State<SkillsAnalysisSection> createState() => _SkillsAnalysisSectionState();
}

class _SkillsAnalysisSectionState extends State<SkillsAnalysisSection> {
  bool showAllMatched = false;
  bool showAllMissing = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = CustomTextTheme.customTextTheme(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.psychology,
                    color: Colors.blue[600],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Skills Analysis",
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Matched Skills Section
            if (widget.matchedSkills.isNotEmpty) ...[
              _buildSkillsSubsection(
                title: 'Matched Skills',
                skills: widget.matchedSkills,
                skillType: 'matched',
                showAll: showAllMatched,
                onToggleShowAll: () =>
                    setState(() => showAllMatched = !showAllMatched),
                icon: Icons.check_circle,
                color: Colors.green,
              ),
              const SizedBox(height: 20),
            ],

            // Missing Skills Section
            if (widget.missingSkills.isNotEmpty) ...[
              _buildSkillsSubsection(
                title: 'Skills to Learn',
                skills: widget.missingSkills,
                skillType: 'missing',
                showAll: showAllMissing,
                onToggleShowAll: () =>
                    setState(() => showAllMissing = !showAllMissing),
                icon: Icons.school,
                color: Colors.orange,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsSubsection({
    required String title,
    required List<String> skills,
    required String skillType,
    required bool showAll,
    required VoidCallback onToggleShowAll,
    required IconData icon,
    required MaterialColor color,
  }) {
    final textTheme = CustomTextTheme.customTextTheme(context).textTheme;
    final displaySkills = showAll ? skills : skills.take(3).toList();
    final hasMore = skills.length > 3;

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
            Text(
              '${skills.length} skills',
              style: textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Skills grid
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: displaySkills
              .map((skill) => _buildSkillChip(skill, skillType, color))
              .toList(),
        ),

        // Show more/less button
        if (hasMore) ...[
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onToggleShowAll,
            icon: Icon(
              showAll ? Icons.expand_less : Icons.expand_more,
              size: 18,
            ),
            label: Text(
              showAll ? 'Show Less' : 'Show ${skills.length - 3} More',
            ),
            style: TextButton.styleFrom(
              foregroundColor: color[600],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSkillChip(String skill, String skillType, MaterialColor color) {
    final isMatched = skillType == 'matched';

    return InkWell(
      onTap: () => widget.onSkillTap(skill),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color[200]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              skill,
              style: TextStyle(
                fontSize: 14,
                color: color[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            if (!isMatched) ...[
              const SizedBox(width: 8),
              InkWell(
                onTap: () => widget.onLearnSkill(skill),
                child: Icon(
                  Icons.play_circle_filled,
                  size: 18,
                  color: color[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
