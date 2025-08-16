// Updated SkillCard
part of '_index.dart';

class SkillCard extends StatelessWidget {
  final String? title, subtitle, description;
  final String? skillType; // New parameter for skill type
  final Icon? icon;
  final double? width;
  final Color? color;
  final void Function()? onPressed;

  const SkillCard({
    super.key,
    this.title,
    this.subtitle,
    this.description,
    this.skillType, // Add skillType parameter
    this.icon,
    this.width,
    this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = CustomTextTheme.customTextTheme(context).textTheme;
    final appTheme = AppTheme.appTheme(context);

    // Determine if this is a user skill or missing skill
    final isUserSkill = skillType == 'user_skill';
    final isMissingSkill = skillType == 'missing_skill';

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: width ?? double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: color ?? appTheme.primary1,
          borderRadius: BorderRadius.circular(10),
          border: skillType != null
              ? Border.all(
                  color: isUserSkill
                      ? Colors.green.withOpacity(0.5)
                      : isMissingSkill
                          ? Colors.orange.withOpacity(0.5)
                          : Colors.transparent,
                  width: 1,
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add skill type badge if skillType is provided
            if (skillType != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isUserSkill
                      ? Colors.green.withOpacity(0.1)
                      : isMissingSkill
                          ? Colors.orange.withOpacity(0.1)
                          : appTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isUserSkill
                      ? 'Your Skill'
                      : isMissingSkill
                          ? 'Recommended'
                          : 'Skill',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isUserSkill
                        ? Colors.green[700]
                        : isMissingSkill
                            ? Colors.orange[700]
                            : appTheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 4),
            ],
            ListTile(
              minLeadingWidth: 0,
              contentPadding: EdgeInsets.zero,
              leading: Container(
                margin: const EdgeInsets.only(top: 5),
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: isUserSkill
                      ? Colors.green.withOpacity(.2)
                      : isMissingSkill
                          ? Colors.orange.withOpacity(.2)
                          : appTheme.primary.withOpacity(.2),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    title.toString()[0],
                    style: textTheme.labelMedium?.copyWith(
                      color: isUserSkill
                          ? Colors.green[700]
                          : isMissingSkill
                              ? Colors.orange[700]
                              : null,
                    ),
                  ),
                ),
              ),
              title: Container(
                alignment: Alignment.center,
                child: Text(
                  title.toString(),
                  style: textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true, // Allow text to wrap to next line
                ),
              ),
              trailing: Icon(
                isUserSkill
                    ? CupertinoIcons.checkmark_circle
                    : isMissingSkill
                        ? CupertinoIcons.plus_circle
                        : CupertinoIcons.bookmark,
                size: 20,
                color: isUserSkill
                    ? Colors.green[700]
                    : isMissingSkill
                        ? Colors.orange[700]
                        : null,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: onPressed,
                child: Text(isUserSkill
                    ? "View Courses"
                    : isMissingSkill
                        ? "Learn Skill"
                        : "Learn Skill"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
