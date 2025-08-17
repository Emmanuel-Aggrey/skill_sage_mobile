part of '_index.dart';

class CourseContentScreen extends StatefulWidget {
  final Map? content;
  const CourseContentScreen({super.key, this.content});

  @override
  State<CourseContentScreen> createState() => _CourseContentScreenState();
}

class _CourseContentScreenState extends State<CourseContentScreen> {
  String _selectedCourseVideo = '';
  String _selectedVideoId = '';
  int _selectedVideoIndex = 0;

  late List courses;
  late List<bool> _isCourseExpanded;

  @override
  void initState() {
    super.initState();
    courses = widget.content!['items'] ?? [];
    _isCourseExpanded = List.generate(courses.length, (index) => false);
    print('Course items: $courses');
  }

  // Helper method to extract YouTube video ID from URL
  String? _extractVideoId(String url) {
    try {
      if (url.isEmpty) return null;

      final uri = Uri.parse(url);
      String? videoId;

      if (uri.host.contains('youtube.com')) {
        videoId = uri.queryParameters['v'];
      } else if (uri.host.contains('youtu.be')) {
        videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
      }

      print('Extracted video ID: $videoId from URL: $url');
      return videoId;
    } catch (e) {
      print('Error extracting video ID from $url: $e');
      return null;
    }
  }

  // Get YouTube thumbnail URL
  String _getVideoThumbnail(String videoId) {
    if (videoId.isEmpty) return '';
    return 'https://img.youtube.com/vi/$videoId/mqdefault.jpg';
  }

  void _playVideo(String videoUrl, int courseIndex, int sessionIndex) {
    if (videoUrl.isEmpty) {
      _showSnackBar('Invalid video URL');
      return;
    }

    final videoId = _extractVideoId(videoUrl);

    if (videoId == null || videoId.isEmpty) {
      _showSnackBar('Could not extract video ID from URL');
      return;
    }

    setState(() {
      _selectedCourseVideo = videoUrl;
      _selectedVideoId = videoId;
      _selectedVideoIndex = sessionIndex + 1;
    });

    // Navigate to video player screen
    final sessionData = courses[courseIndex]['sessions'][sessionIndex];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YouTubeVideoPlayerScreen(
          videoId: videoId,
          title: sessionData['name'] ?? 'Video',
          channelName: courses[courseIndex]['name'],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = CustomTextTheme.customTextTheme(context).textTheme;
    final appTheme = AppTheme.appTheme(context);

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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Course Content",
          style: textTheme.labelMedium,
        ),
        centerTitle: true,
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
        child: (courses.isEmpty)
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/not_found.png"),
                    const SizedBox(height: 16),
                    Text(
                      'No course content available',
                      style: textTheme.bodyLarge,
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  // Video Preview Section
                  Container(
                    width: double.infinity,
                    height: 220,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _buildVideoPreview(textTheme),
                    ),
                  ),

                  // Course Content List
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SingleChildScrollView(
                        child: ExpansionPanelList(
                          animationDuration: const Duration(milliseconds: 300),
                          dividerColor: appTheme.primary.withOpacity(.4),
                          elevation: 1,
                          expandedHeaderPadding: EdgeInsets.zero,
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              _isCourseExpanded[index] =
                                  !_isCourseExpanded[index];
                            });
                          },
                          children: _buildExpansionPanels(textTheme, appTheme),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildVideoPreview(TextTheme textTheme) {
    if (_selectedVideoId.isEmpty) {
      return Container(
        color: Colors.grey[900],
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.play_circle_outline,
                size: 64,
                color: Colors.white54,
              ),
              SizedBox(height: 8),
              Text(
                'Select a video to preview',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          _getVideoThumbnail(_selectedVideoId),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[800],
              child: const Icon(
                Icons.video_library,
                size: 64,
                color: Colors.white54,
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey[800],
              child: const Center(
                child: CircularProgressIndicator(color: Colors.red),
              ),
            );
          },
        ),
        Container(
          color: Colors.black.withValues(alpha: 0.3),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 48,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          left: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Tap to play video',
              style: textTheme.bodySmall?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  List<ExpansionPanel> _buildExpansionPanels(TextTheme textTheme, appTheme) {
    return List.generate(courses.length, (index) {
      final course = courses[index];
      final sessions = course['sessions'] as List? ?? [];

      return ExpansionPanel(
        backgroundColor: appTheme.scaffold,
        headerBuilder: (context, isExpanded) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Section ${index + 1}: ${course['name']}",
                style: textTheme.headlineMedium,
              ),
              const SizedBox(height: 5),
              Text(
                "${sessions.length} video${sessions.length != 1 ? 's' : ''}",
                style: textTheme.labelSmall,
              ),
            ],
          ),
        ),
        body: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, sessionIndex) => const Divider(height: 1),
          shrinkWrap: true,
          itemCount: sessions.length,
          itemBuilder: (context, sessionIndex) {
            final session = sessions[sessionIndex];
            final isCurrentlySelected =
                _selectedCourseVideo == session['video'];
            final videoId = _extractVideoId(session['video'] ?? '');

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  print('Tapped video: ${session['video']}');
                  _playVideo(session['video'] ?? '', index, sessionIndex);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isCurrentlySelected
                        ? appTheme.primary.withOpacity(0.1)
                        : Colors.transparent,
                    border: Border(
                      left: BorderSide(
                        color: isCurrentlySelected
                            ? appTheme.primary
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Video thumbnail
                      Container(
                        width: 60,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.grey[300],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              if (videoId != null)
                                Image.network(
                                  _getVideoThumbnail(videoId),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[400],
                                      child: const Icon(
                                        Icons.video_library,
                                        size: 20,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                )
                              else
                                Container(
                                  color: Colors.grey[400],
                                  child: const Icon(
                                    Icons.video_library,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Video info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${sessionIndex + 1}. ${session['name'] ?? 'Untitled Video'}",
                              style: textTheme.labelMedium?.copyWith(
                                fontWeight: isCurrentlySelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isCurrentlySelected
                                    ? appTheme.primary
                                    : null,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  isCurrentlySelected
                                      ? Icons.play_circle_filled
                                      : Icons.play_circle_outline,
                                  size: 16,
                                  color: isCurrentlySelected
                                      ? appTheme.primary
                                      : Colors.grey[600],
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  session["time"] ?? "Duration not available",
                                  style: textTheme.labelSmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const Spacer(),
                                if (isCurrentlySelected)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: appTheme.primary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Selected',
                                      style: textTheme.labelSmall?.copyWith(
                                        color: Colors.white,
                                        fontSize: 10,
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
              ),
            );
          },
        ),
        isExpanded: _isCourseExpanded[index],
      );
    });
  }
}
