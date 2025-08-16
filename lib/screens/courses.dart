part of '_index.dart';

class CoursesScreen extends ConsumerWidget {
  final Map? skill;
  const CoursesScreen({super.key, this.skill});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = AppTheme.appTheme(context);
    final textTheme = CustomTextTheme.customTextTheme(context).textTheme;
    return Scaffold(
      backgroundColor: appTheme.bg1,
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            CupertinoIcons.arrow_left,
            size: 20,
            color: appTheme.txt,
          ),
          onPressed: Navigator.of(context).pop,
        ),
        title: Center(
          child: Text(
            "Available Courses",
            style: textTheme.labelMedium,
          ),
        ),
        elevation: 0,
        backgroundColor: appTheme.scaffold,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.bookmark,
              size: 20,
              color: appTheme.txt,
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: AdvancedFutureBuilder(
        future: () {
          final skillName = skill!['skill'];
          print('Searching courses for skill: $skillName');
          return ref.watch(courseProvider).searchCourse(skillName);
        },
        builder: (context, snapshot, _) {
          print(
              'Course search result: ${snapshot.result?.length ?? 0} courses found');
          if (snapshot.result == null || snapshot.result.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.school_outlined,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No courses found for this skill',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Our AI curated top lessons just for to you get started!',
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.youtubeVideosRoute,
                        arguments: skill,
                      );
                    },
                    icon: const Icon(Icons.play_circle_outline),
                    label: const Text('Explore Videos'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              // Explore Videos button when courses are found
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.youtubeVideosRoute,
                      arguments: skill,
                    );
                  },
                  icon: const Icon(Icons.play_circle_outline),
                  label: const Text('Explore Videos'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                ),
              ),
              // Courses list
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  shrinkWrap: true,
                  itemBuilder: (_, index) => GestureDetector(
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.courseDetails,
                        arguments: {"data": snapshot.result[index]}),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                          minLeadingWidth: 0,
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: (snapshot.result[index]['image'] == null)
                                  ? const DecorationImage(
                                      image: AssetImage(
                                          'assets/images/default.jpg'),
                                      fit: BoxFit.cover,
                                    )
                                  : DecorationImage(
                                      image: NetworkImage(
                                          snapshot.result[index]['image']),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          title: Text(
                            snapshot.result[index]['title'],
                            style: textTheme.headlineMedium,
                          ),
                          subtitle: Text(
                            snapshot.result[index]['sub_title'],
                            style: textTheme.bodySmall,
                          )),
                    ),
                  ),
                  itemCount: snapshot.result.length,
                ),
              ),
            ],
          );
        },
        errorBuilder: (context, error, reload) => Center(
          child: Text(
            error.toString(),
            style: textTheme.bodyMedium,
          ),
        ),
      )),
    );
  }
}
