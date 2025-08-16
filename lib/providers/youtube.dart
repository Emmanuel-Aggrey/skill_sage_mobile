part of '_index.dart';

final youtubeProvider = ChangeNotifierProvider((ref) => YoutubeProvider(ref));

class YoutubeVideo {
  final String id;
  final String title;
  final String description;
  final String thumbnail;
  final String url;
  final String duration;
  final int viewCount;
  final int likeCount;
  final String publishedDate;
  final String channelName;
  final String skill;
  final String level;

  YoutubeVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.url,
    required this.duration,
    required this.viewCount,
    required this.likeCount,
    required this.publishedDate,
    required this.channelName,
    required this.skill,
    required this.level,
  });

  factory YoutubeVideo.fromJson(Map<String, dynamic> json) {
    return YoutubeVideo(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      url: json['url'] ?? '',
      duration: json['duration'] ?? '',
      viewCount: json['view_count'] ?? 0,
      likeCount: json['like_count'] ?? 0,
      publishedDate: json['published_date'] ?? '',
      channelName: json['channel_name'] ?? '',
      skill: json['skill'] ?? '',
      level: json['level'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'url': url,
      'duration': duration,
      'view_count': viewCount,
      'like_count': likeCount,
      'published_date': publishedDate,
      'channel_name': channelName,
      'skill': skill,
      'level': level,
    };
  }
}

class YoutubeProvider extends ChangeNotifier {
  Ref ref;
  List<YoutubeVideo> videos = [];
  bool isLoading = false;
  String? error;

  Dio get http => ref.read(httpProvider).http;

  YoutubeProvider(this.ref);

  Future<List<YoutubeVideo>> getVideosForSkill(String skill,
      {String level = "beginner", int maxVideos = 10}) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // Use the new API endpoint but keep the old implementation style
      final response = await cather(() => http.get(
            '/youtube/videos/',
            queryParameters: {
              'skill': skill,
              'level': level,
              'max_videos': maxVideos,
            },
          ));

      if (response.success && response.result != null) {
        final videosData = response.result['videos'] as List<dynamic>? ?? [];
        final videoList =
            videosData.map((video) => YoutubeVideo.fromJson(video)).toList();

        videos = videoList;
        isLoading = false;
        notifyListeners();
        return videoList;
      } else {
        error = response.error ?? 'Failed to load videos';
        isLoading = false;
        notifyListeners();
        return [];
      }
    } catch (e) {
      error = 'Error loading videos: $e';
      isLoading = false;
      notifyListeners();
      return [];
    }
  }

  Future<List<YoutubeVideo>> getVideosForSkills(List<String> skills,
      {String level = "beginner", int maxVideos = 10}) async {
    if (skills.isEmpty) return [];

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await cather(() => http.get(
            '/youtube/videos/batch',
            queryParameters: {
              'skills': skills,
              'level': level,
              'max_videos': maxVideos,
            },
          ));

      if (response.success && response.result != null) {
        final videosData = response.result['videos'] as List<dynamic>? ?? [];
        final videoList =
            videosData.map((video) => YoutubeVideo.fromJson(video)).toList();

        videos = videoList;
        isLoading = false;
        notifyListeners();
        return videoList;
      } else {
        error = response.error ?? 'Failed to load videos';
        isLoading = false;
        notifyListeners();
        return [];
      }
    } catch (e) {
      error = 'Error loading videos: $e';
      isLoading = false;
      notifyListeners();
      return [];
    }
  }

  Future<List<YoutubeVideo>> getRecommendedVideos(int userId,
      {int maxVideos = 20}) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await cather(() => http.get(
            '/youtube/videos/recommended/$userId',
            queryParameters: {
              'max_videos': maxVideos,
            },
          ));

      if (response.success && response.result != null) {
        final videosData = response.result['videos'] as List<dynamic>? ?? [];
        final videoList =
            videosData.map((video) => YoutubeVideo.fromJson(video)).toList();

        videos = videoList;
        isLoading = false;
        notifyListeners();
        return videoList;
      } else {
        error = response.error ?? 'Failed to load recommended videos';
        isLoading = false;
        notifyListeners();
        return [];
      }
    } catch (e) {
      error = 'Error loading recommended videos: $e';
      isLoading = false;
      notifyListeners();
      return [];
    }
  }

  void clearVideos() {
    videos.clear();
    error = null;
    notifyListeners();
  }

  String formatViewCount(int viewCount) {
    if (viewCount >= 1000000) {
      return '${(viewCount / 1000000).toStringAsFixed(1)}M views';
    } else if (viewCount >= 1000) {
      return '${(viewCount / 1000).toStringAsFixed(1)}K views';
    } else {
      return '$viewCount views';
    }
  }

  String formatLikeCount(int likeCount) {
    if (likeCount >= 1000000) {
      return '${(likeCount / 1000000).toStringAsFixed(1)}M';
    } else if (likeCount >= 1000) {
      return '${(likeCount / 1000).toStringAsFixed(1)}K';
    } else {
      return '$likeCount';
    }
  }
}
