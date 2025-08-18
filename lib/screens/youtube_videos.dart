part of '_index.dart';

class YoutubeVideosScreen extends ConsumerStatefulWidget {
  final dynamic skill;
  const YoutubeVideosScreen({super.key, this.skill});

  @override
  ConsumerState<YoutubeVideosScreen> createState() =>
      _YoutubeVideosScreenState();
}

class _YoutubeVideosScreenState extends ConsumerState<YoutubeVideosScreen> {
  List<YoutubeVideo> videos = [];
  bool isLoading = true;
  String? error;

  final ScrollController _scrollController = ScrollController();
  int _pageSize = 5;
  int _currentPage = 0;
  bool _hasMoreVideos = true;
  bool _isPaginating = false;

  @override
  void initState() {
    super.initState();
    _loadVideos(isInitialLoad: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadVideos({bool isInitialLoad = false}) async {
    print('[_loadVideos] Function called. isInitialLoad: $isInitialLoad');

    if (isInitialLoad) {
      setState(() {
        isLoading = true;
        error = null;
        _currentPage = 0; // Reset pagination state
        _hasMoreVideos = true;
      });
    } else {
      // For pagination, don't show full loading state
      if (_isPaginating) return; // Prevent multiple simultaneous requests
      setState(() {
        _isPaginating = true;
        error = null;
      });
    }

    try {
      final youtubeProv = ref.read(youtubeProvider);

      print(
          '[_loadVideos] Before fetch - currentPage: $_currentPage, hasMoreVideos: $_hasMoreVideos');
      print(
          '[_loadVideos] Videos list length before modification: ${videos.length}');

      String skillName = 'general';
      if (widget.skill is String) {
        skillName = widget.skill as String;
      } else if (widget.skill is List<String> && widget.skill.isNotEmpty) {
        skillName = widget.skill![0];
      } else if (widget.skill is Map && widget.skill.containsKey('skill')) {
        skillName = widget.skill['skill'] as String;
      }

      // Calculate the correct offset
      final offset = isInitialLoad ? 0 : _currentPage * _pageSize;
      print('[_loadVideos] Using offset: $offset for page: $_currentPage');

      final loadedVideos = await youtubeProv.getVideosForSkill(
        skillName,
        offset: offset,
        limit: _pageSize,
      );

      print('[_loadVideos] Loaded ${loadedVideos.length} videos');

      if (mounted) {
        setState(() {
          if (isInitialLoad) {
            videos = loadedVideos;
            _currentPage = 1; // Set to 1 after loading first page
          } else {
            videos.addAll(loadedVideos);
            _currentPage++; // Increment page after successful load
          }

          _hasMoreVideos = loadedVideos.length == _pageSize;
          isLoading = false;
          _isPaginating = false;

          print(
              '[_loadVideos] After update - videos.length: ${videos.length}, currentPage: $_currentPage, hasMoreVideos: $_hasMoreVideos');
        });
      }

      print('Total videos loaded: ${videos.length}');
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Failed to load videos: $e';
          isLoading = false;
          _isPaginating = false;
        });
      }
      print('Error loading YouTube videos: $e');
    }
  }

  Future<void> _onScroll() async {
    print(
        '[_onScroll] Scroll event detected. isLoading: $isLoading, isPaginating: $_isPaginating, hasMoreVideos: $_hasMoreVideos, currentPage: $_currentPage');
    print(
        '[_onScroll] Scroll position: ${_scrollController.position.pixels}/${_scrollController.position.maxScrollExtent}');

    // Check if we're at the bottom and can load more
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent -
                100 && // Add small buffer
        !isLoading &&
        !_isPaginating &&
        _hasMoreVideos &&
        _currentPage < 6) {
      print('[_onScroll] Triggering pagination load');
      await _loadVideos(isInitialLoad: false);
    }
  }

  void _launchVideo(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open video')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening video: $e')),
        );
      }
    }
  }

  void _shareVideo(YoutubeVideo video) async {
    try {
      final shareText =
          '${video.title}\n\nWatch this ${video.skill} tutorial:\n${video.url}';
      await Share.share(shareText);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video shared!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing video: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.appTheme(context);
    final textTheme = CustomTextTheme.customTextTheme(context).textTheme;
    String skillName = 'Unknown Skill';
    if (widget.skill is String) {
      skillName = widget.skill as String;
    } else if (widget.skill is List<String> && widget.skill.isNotEmpty) {
      skillName = widget.skill![0];
    } else if (widget.skill is Map && widget.skill.containsKey('skill')) {
      skillName = widget.skill['skill'] as String;
    }

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
            "$skillName Videos",
            style: textTheme.labelMedium,
          ),
        ),
        elevation: 0,
        backgroundColor: appTheme.scaffold,
        actions: [
          IconButton(
            onPressed: () => _loadVideos(isInitialLoad: true),
            icon: Icon(
              CupertinoIcons.refresh,
              size: 20,
              color: appTheme.txt,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Error loading videos',
                            style: textTheme.headlineSmall),
                        const SizedBox(height: 8),
                        Text(error!,
                            style: textTheme.bodySmall,
                            textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _loadVideos(isInitialLoad: true),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : videos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.video_library_outlined,
                                size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text('No videos found',
                                style: textTheme.headlineSmall),
                            const SizedBox(height: 8),
                            Text('Try searching for a different skill',
                                style: textTheme.bodySmall),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        controller: _scrollController,
                        itemCount: videos.length +
                            (_hasMoreVideos || _currentPage >= 6 ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == videos.length) {
                            return _buildLoadMoreIndicator();
                          }
                          final video = videos[index];
                          return _buildVideoCard(video, textTheme, appTheme);
                        },
                      ),
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: _isPaginating
            ? const CircularProgressIndicator()
            : _hasMoreVideos && _currentPage < 6
                ? ElevatedButton(
                    onPressed: () => _loadVideos(isInitialLoad: false),
                    child: const Text('Load More Videos'),
                  )
                : ElevatedButton(
                    onPressed: () {
                      _scrollController.animateTo(
                        0.0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                      );
                    },
                    child: const Text('Scroll Up'),
                  ),
      ),
    );
  }

  Widget _buildVideoCard(YoutubeVideo video, TextTheme textTheme, appTheme) {
    final youtubeProv = ref.read(youtubeProvider);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _launchVideo(video.url),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(8)),
                  child: Image.network(
                    video.thumbnail,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.video_library, size: 64),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      video.duration,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Video info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    video.channelName,
                    style:
                        textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${youtubeProv.formatViewCount(video.viewCount)} • ${video.publishedDate}',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (video.description.isNotEmpty)
                    Text(
                      video.description,
                      style: textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.thumb_up_outlined,
                              size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            youtubeProv.formatLikeCount(video.likeCount),
                            style: textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => _shareVideo(video),
                        icon: const Icon(Icons.share, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
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
