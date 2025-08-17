part of '_index.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User? user = ref.watch(userProvider).user;

    final appTheme = AppTheme.appTheme(context);

    return Scaffold(
      backgroundColor: appTheme.bg1,
      body: SafeArea(
        child: Column(
          children: [
            ProfileHeader(
              name: (user != null) ? user.name : '',
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Expanded(
              child: Profiles(),
            ),
          ],
        ),
      ),
    );
  }
}

// Header
class ProfileHeader extends ConsumerWidget {
  final String? name;
  const ProfileHeader({super.key, this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = AppTheme.appTheme(context);
    final textTheme = CustomTextTheme.customTextTheme(context).textTheme;
    final prov = ref.watch(userProvider);
    final user = prov.user;
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 0.0),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/Background.png"),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25.0),
          bottomRight: Radius.circular(25.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.refresh_outlined,
                    color: appTheme.light,
                    size: 20,
                  ),
                  onPressed: () async {
                    // Show confirmation dialog
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Refresh All Matches'),
                          content: const Text(
                            'This will refresh all your job matches. This may take a few moments. Do you want to continue?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Refresh'),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmed == true && context.mounted) {
                      try {
                        // Show loading indicator
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Refreshing matches...'),
                            duration: Duration(seconds: 2),
                          ),
                        );

                        // Call refresh API
                        await ref
                            .read(userProvider.notifier)
                            .refreshAllMatches();

                        // Show success message
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Matches refreshed successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        // Show error message
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error refreshing matches: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
                  },
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.settings,
                    color: appTheme.light,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.settingsRoute,
                  ),
                ),
              ],
            ),
            Transform.translate(
              offset: const Offset(0, -15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      // Pick and upload profile image
                      final picker = ImagePicker();
                      final pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);

                      if (pickedFile != null) {
                        final userProv = ref.read(userProvider.notifier);
                        await userProv
                            .uploadProfileImage(File(pickedFile.path));
                      }
                    },
                    child: (user == null || user.profileImage == null)
                        ? const CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                AssetImage("assets/images/blank_profile.jpg"),
                          )
                        : CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                              user.profileImage.toString(),
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    name.toString(),
                    style: textTheme.labelLarge,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // Text(
                  //   // location.toString(),
                  //   style: textTheme.labelSmall,
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${user?.bookmarkCount ?? 0} Bookmarks',
                        style: textTheme.headlineSmall,
                      ),
                      Text(user?.profile?.location ?? '',
                          style: textTheme.headlineSmall),
                      // Text(user?.llmInsights?.primaryDomain ?? 'No domain',style: textTheme.headlineSmall),
                      InkWell(
                        onTap: () => Navigator.of(context)
                            .pushNamed(AppRoutes.editProfile),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          decoration: BoxDecoration(
                              color: appTheme.light.withOpacity(.15),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Text('Edit Profile',
                                  style: textTheme.headlineSmall),
                              const SizedBox(width: 15),
                              Icon(
                                Icons.edit_sharp,
                                size: 20,
                                color: appTheme.light,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Profiles
class Profiles extends ConsumerStatefulWidget {
  const Profiles({super.key});

  @override
  ConsumerState<Profiles> createState() => _ProfilesState();
}

class _ProfilesState extends ConsumerState<Profiles> {
  final List<File?> _resume = [];
  bool _isSkillsExpanded = false;
  Future<void> pickResume() async {
    final resume = ref.read(userProvider.notifier);
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null) {
        File file = File(result.files.single.path.toString());
        await resume.uploadResume(resume: file);
        setState(
          () => _resume.add(file),
        );
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  String formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    String formattedDate = DateFormat('d MMM y').format(date);
    String formattedTime = DateFormat('h:mm a').format(date);
    return '$formattedDate at $formattedTime';
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.appTheme(context);
    final textTheme = CustomTextTheme.customTextTheme(context).textTheme;

    final prov = ref.watch(userProvider);
    User? user = prov.user;

    // remove the scaffold
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        // LLM Insights Section
        if (user != null && user.llmInsights != null)
          _buildLLMInsightsCard(user.llmInsights!, textTheme, appTheme),

        (user == null || user.profile.about == null)
            ? EmptyProfileCard(
                title: 'About me',
                leadingIcon: Icon(
                  CupertinoIcons.profile_circled,
                  color: appTheme.primary2,
                ),
                trailingIcon: IconButton(
                  icon: Icon(
                    CupertinoIcons.add_circled_solid,
                    color: appTheme.primary2,
                  ),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.editAbout,
                  ),
                ),
              )
            : ProfileCard(
                title: 'About me',
                leadingIcon: Icon(
                  CupertinoIcons.profile_circled,
                  color: appTheme.primary2,
                ),
                trailingIcon: IconButton(
                  icon: Icon(
                    Icons.edit_sharp,
                    size: 20,
                    color: appTheme.primary2,
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.editAbout),
                ),
                widget: Text(
                  user.profile.about.toString(),
                  style: textTheme.labelSmall,
                ),
              ),
        (user == null || user.experience?.isEmpty == true)
            ? EmptyProfileCard(
                title: 'Work Experience',
                leadingIcon: Icon(
                  CupertinoIcons.briefcase,
                  color: appTheme.primary2,
                ),
                trailingIcon: IconButton(
                  icon: Icon(
                    CupertinoIcons.add_circled_solid,
                    color: appTheme.primary2,
                  ),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.experienceRoute,
                  ),
                ),
              )
            : ProfileCard(
                title: 'Work Experience',
                leadingIcon: Icon(
                  CupertinoIcons.briefcase,
                  color: appTheme.primary2,
                ),
                trailingIcon: IconButton(
                  icon: Icon(
                    CupertinoIcons.add_circled_solid,
                    color: appTheme.primary2,
                  ),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.experienceRoute,
                  ),
                ),
                widget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (user.experience ?? [])
                      .map(
                        (e) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              minVerticalPadding: 0,
                              title: Text(
                                e.jobTitle,
                                style: textTheme.labelMedium,
                              ),
                              trailing: IconButton(
                                  icon: Icon(
                                    Icons.edit_sharp,
                                    size: 20,
                                    color: appTheme.primary2,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.experienceRoute,
                                      arguments: e,
                                    );
                                  }),
                            ),
                            Text(
                              e.companyName,
                              style: textTheme.labelSmall,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${e.startDate} - ${e.endDate ?? 'present'} . ${e.endDate != null ? '${(int.parse(e.endDate!.split('-')[0]) - int.parse(e.startDate.split('-')[0])).toString()} Years' : "works here"}',
                              style: textTheme.labelSmall,
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
        (user == null || user.education?.isEmpty == true)
            ? EmptyProfileCard(
                title: 'Education',
                leadingIcon: Icon(
                  CupertinoIcons.book,
                  color: appTheme.primary2,
                ),
                trailingIcon: IconButton(
                  icon: Icon(
                    CupertinoIcons.add_circled_solid,
                    color: appTheme.primary2,
                  ),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.educationRoute,
                  ),
                ),
              )
            : ProfileCard(
                title: 'Education',
                leadingIcon: Icon(
                  CupertinoIcons.book,
                  color: appTheme.primary2,
                ),
                trailingIcon: IconButton(
                  icon: Icon(
                    CupertinoIcons.add_circled_solid,
                    color: appTheme.primary2,
                  ),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.educationRoute,
                  ),
                ),
                widget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (user.education ?? [])
                      .map(
                        (e) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              minVerticalPadding: 0,
                              title: Text(
                                e.program,
                                style: textTheme.labelMedium,
                              ),
                              trailing: IconButton(
                                  icon: Icon(
                                    Icons.edit_sharp,
                                    size: 20,
                                    color: appTheme.primary2,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.educationRoute,
                                      arguments: e,
                                    );
                                  }),
                            ),
                            Text(
                              e.institution,
                              style: textTheme.labelSmall,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${e.startDate} - ${e.endDate ?? 'present'} . ${e.endDate != null ? '${(int.parse(e.endDate!.split('-')[0]) - int.parse(e.startDate.split('-')[0])).toString()} Years' : "works here"}',
                              style: textTheme.labelSmall,
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),

        (user == null || user.skills?.isEmpty == true)
            ? EmptyProfileCard(
                title: 'Skills',
                leadingIcon: Icon(
                  CupertinoIcons.square_stack_3d_up,
                  color: appTheme.primary2,
                ),
                trailingIcon: IconButton(
                  icon: Icon(
                    CupertinoIcons.add_circled_solid,
                    color: appTheme.primary2,
                  ),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.editSkills,
                  ),
                ),
              )
            : ProfileCard(
                title: 'Skills',
                leadingIcon: Icon(
                  CupertinoIcons.square_stack_3d_up,
                  color: appTheme.primary2,
                ),
                trailingIcon: IconButton(
                  icon: Icon(
                    Icons.edit_sharp,
                    size: 20,
                    color: appTheme.primary2,
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.editSkills),
                ),
                widget: _buildCollapsibleSkills(user.skills ?? []),
              ),
        (user == null || user.profile.languages == null)
            ? EmptyProfileCard(
                title: 'Languages',
                leadingIcon: Icon(
                  CupertinoIcons.globe,
                  color: appTheme.primary2,
                ),
                trailingIcon: IconButton(
                  icon: Icon(
                    CupertinoIcons.add_circled_solid,
                    color: appTheme.primary2,
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.editLang),
                ),
              )
            : ProfileCard(
                title: 'Languages',
                leadingIcon: Icon(
                  CupertinoIcons.globe,
                  color: appTheme.primary2,
                ),
                trailingIcon: IconButton(
                  icon: Icon(
                    Icons.edit_sharp,
                    size: 20,
                    color: appTheme.primary2,
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.editLang),
                ),
                widget: Wrap(
                  spacing: 10,
                  children: user.profile.languages!
                      .map(
                        (e) => Chip(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                          label: Text(e),
                        ),
                      )
                      .toList(),
                ),
              ),
        // awards
        // EmptyProfileCard(
        //   title: 'Awards',
        //   leadingIcon: Icon(
        //     CupertinoIcons.gift,
        //     color: appTheme.primary2,
        //   ),
        //   trailingIcon: IconButton(
        //     icon: Icon(
        //       CupertinoIcons.add_circled_solid,
        //       color: appTheme.primary2,
        //     ),
        //     onPressed: () => {},
        //   ),
        // ),
        // cv
        (user == null || user.resume?.isEmpty == true)
            ? EmptyProfileCard(
                title: 'Resume',
                leadingIcon: Icon(
                  CupertinoIcons.doc_person,
                  color: appTheme.primary2,
                ),
                trailingIcon: IconButton(
                  icon: Icon(
                    CupertinoIcons.add_circled_solid,
                    color: appTheme.primary2,
                  ),
                  onPressed: pickResume,
                ),
              )
            : ProfileCard(
                title: 'Resume',
                leadingIcon: Icon(
                  CupertinoIcons.doc_person,
                  color: appTheme.primary2,
                ),
                trailingIcon: IconButton(
                  icon: Icon(
                    CupertinoIcons.add_circled_solid,
                    color: appTheme.primary2,
                  ),
                  onPressed: pickResume,
                ),
                widget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [...(user.resume ?? []).map((e) => File(e))].map(
                    (e) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: SvgPicture.asset("assets/svgs/PDF.svg"),
                        title: Text(
                          e.path.split('/').last.toString(),
                          style: textTheme.labelMedium,
                        ),
                        // subtitle: Text(
                        //   '${e.lengthSync()} Kb . ${formatDate(
                        //     e.lastAccessedSync().toString(),
                        //   )}',
                        //   style: textTheme.labelSmall,
                        // ),
                        trailing: IconButton(
                          icon: Icon(
                            CupertinoIcons.delete_simple,
                            color: appTheme.danger,
                          ),
                          onPressed: () => {
                            prov.removeResume(
                              url: e.path,
                            )
                          },
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
      ],
    );
  }

  Widget _buildLLMInsightsCard(
      LLMInsights insights, TextTheme textTheme, AppTheme appTheme) {
    return ProfileCard(
      title: 'AI Career Insights',
      leadingIcon: Icon(
        Icons.psychology,
        color: appTheme.primary2,
      ),
      trailingIcon: IconButton(
        icon: Icon(
          Icons.refresh,
          size: 0,
          color: appTheme.primary2,
        ),
        onPressed: () async {
          // Refresh insights
          await ref.read(userProvider.notifier).reloadUser();
        },
      ),
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (insights.careerStage != null) ...[
            _buildInsightRow(
                'Career Stage', insights.careerStage!, Icons.work_outline),
            const SizedBox(height: 8),
          ],
          if (insights.primaryDomain != null) ...[
            _buildInsightRow(
                'Primary Domain', insights.primaryDomain!, Icons.domain),
            const SizedBox(height: 8),
          ],
          if (insights.yearsExperience != null) ...[
            _buildInsightRow('Experience', '${insights.yearsExperience} years',
                Icons.timeline),
            const SizedBox(height: 12),
          ],
          if (insights.keyStrengths != null &&
              insights.keyStrengths!.isNotEmpty) ...[
            Text(
              'Key Strengths',
              style:
                  textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: insights.keyStrengths!
                  .map((strength) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green[200]!),
                        ),
                        child: Text(
                          strength,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 12),
          ],
          if (insights.growthAreas != null &&
              insights.growthAreas!.isNotEmpty) ...[
            Text(
              'Growth Areas',
              style:
                  textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: insights.growthAreas!
                  .map((area) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.orange[200]!),
                        ),
                        child: Text(
                          area,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 12),
          ],
          if (insights.recommendedRoles != null &&
              insights.recommendedRoles!.isNotEmpty) ...[
            Text(
              'Recommended Roles',
              style:
                  textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: insights.recommendedRoles!
                  .map((role) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Text(
                          role,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInsightRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }

  Widget _buildCollapsibleSkills(List<dynamic> skills) {
    const int maxSkillsToShow = 5;
    final skillsToShow =
        _isSkillsExpanded ? skills : skills.take(maxSkillsToShow).toList();
    final hasMoreSkills = skills.length > maxSkillsToShow;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          children: skillsToShow
              .map(
                (e) => Chip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.0),
                  ),
                  label: Text(e['name'].toString()),
                ),
              )
              .toList(),
        ),
        if (hasMoreSkills)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isSkillsExpanded = !_isSkillsExpanded;
                });
              },
              child: Text(
                _isSkillsExpanded
                    ? 'Show Less'
                    : 'View All (${skills.length - maxSkillsToShow} more)',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
