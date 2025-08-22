part of '_index.dart';

class BookmarkScreen extends ConsumerStatefulWidget {
  const BookmarkScreen({super.key});
  @override
  ConsumerState<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends ConsumerState<BookmarkScreen> {
  Future<void> remove(WidgetRef ref, int id, BuildContext context) async {
    final resp = await ref.read(jobProvider).removeBookmark(id: id);
    if (resp) {
      showToast(context, 'removed');
    }
  }

  Future<void> add(WidgetRef ref, int id, BuildContext context) async {
    final resp = await ref.read(jobProvider).addApplication(id: id);
    if (resp) {
      showToast(context, 'applied');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = CustomTextTheme.customTextTheme(context).textTheme;
    final appTheme = AppTheme.appTheme(context);
    return SafeArea(
      child: Column(children: [
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
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Expanded(
          child: AdvancedFutureBuilder(
            future: () => ref.read(jobProvider).loadBookmark(),
            builder: (context, snapshot, _) {
              return Consumer(builder: (context, ref, child) {
                var jobs = ref.watch(jobProvider);
                return ListView.separated(
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  shrinkWrap: true,
                  itemCount: jobs.bookmarks.length,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemBuilder: (context, index) {
                    final job = jobs.bookmarks[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Job Image/Icon
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: appTheme.primary.withOpacity(0.1),
                            ),
                            child: job['image'] != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      job['image'],
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                        Icons.business,
                                        color: appTheme.primary,
                                        size: 24,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    Icons.business,
                                    color: appTheme.primary,
                                    size: 24,
                                  ),
                          ),
                          const SizedBox(width: 12),

                          // Job Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Job Title - Expandable
                                GestureDetector(
                                  onTap: () =>
                                      _showFullTitle(context, job['title']),
                                  child: Text(
                                    job['title'] ?? 'No Title',
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      height: 1.3,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 4),

                                // Company Name
                                Text(
                                  job['company'] ?? 'Company',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: appTheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),

                                // Location and Type
                                Row(
                                  children: [
                                    if (job['location'] != null) ...[
                                      Icon(
                                        Icons.location_on_outlined,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          job['location'],
                                          style: textTheme.bodySmall?.copyWith(
                                            color: Colors.grey[600],
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                    if (job['location'] != null &&
                                        job['type'] != null)
                                      Text(
                                        ' • ',
                                        style: textTheme.bodySmall?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    if (job['type'] != null)
                                      Text(
                                        job['type'],
                                        style: textTheme.bodySmall?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // External job indicator
                                if (job['is_external'] == true)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.orange.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Text(
                                      'External',
                                      style: textTheme.labelSmall?.copyWith(
                                        color: Colors.orange[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // Action Buttons
                          Column(
                            children: [
                              IconButton(
                                onPressed: () =>
                                    remove(ref, job['id'], context),
                                icon: const Icon(Icons.bookmark_remove),
                                color: Colors.red,
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.red.withOpacity(0.1),
                                  minimumSize: const Size(40, 40),
                                ),
                              ),
                              // Only show apply button for internal jobs
                              if (job['is_external'] != true) ...[
                                const SizedBox(height: 8),
                                IconButton(
                                  onPressed: () => add(ref, job['id'], context),
                                  icon: const Icon(Icons.send),
                                  color: Colors.green,
                                  style: IconButton.styleFrom(
                                    backgroundColor:
                                        Colors.green.withOpacity(0.1),
                                    minimumSize: const Size(40, 40),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              });
            },
            errorBuilder: (context, error, reload) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
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
            emptyBuilder: (context, reload) => SizedBox(
              child: Image.asset("assets/images/not_found.png"),
            ),
          ),
        ),
      ]),
    );
  }

  void _showFullTitle(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Job Title'),
          content: Text(title),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
