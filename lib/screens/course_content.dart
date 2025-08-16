part of '_index.dart';

class CourseContentScreen extends StatefulWidget {
  final Map? content;
  const CourseContentScreen({super.key, this.content});

  @override
  State<CourseContentScreen> createState() => _CourseContentScreenState();
}

class _CourseContentScreenState extends State<CourseContentScreen> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  String _selectedCourseVideo = '';
  int _selectedVideoIndex = 1;

  late List courses;

  // final List<bool> _isCourseExpanded = List.generate(2, (index) => false);

  late List<bool> _isCourseExpanded;

  @override
  void initState() {
    super.initState();
    courses = widget.content!['items'];
    _isCourseExpanded = List.generate(courses.length, (index) => false);
    print(courses);

    // Initialize controllers
    _idController = TextEditingController();
    _seekToController = TextEditingController();

    // Get initial video ID with proper validation
    String initialVideoId = '';
    if (courses.isNotEmpty &&
        courses[0]['sessions'] != null &&
        courses[0]['sessions'].isNotEmpty &&
        courses[0]['sessions'][0]['video'] != null) {
      initialVideoId = courses[0]['sessions'][0]['video'];
    }

    _controller = YoutubePlayerController(
      initialVideoId: initialVideoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false, // Changed to false for better UX
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );

    // Set initial selected video
    if (initialVideoId.isNotEmpty) {
      _selectedCourseVideo = initialVideoId;
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  void playCourse(String video) {
    if (video.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid video ID')),
      );
      return;
    }

    setState(() {
      if (_selectedCourseVideo == video) {
        _controller.pause();
        _selectedCourseVideo = "";
      } else {
        try {
          _controller.load(video);
          _selectedCourseVideo = video;
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading video: $e')),
          );
        }
      }
    });
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
          onPressed: Navigator.of(context).pop,
        ),
        title: Center(
          child: Text(
            "Course Content",
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
        child: (courses.isEmpty)
            ? Center(
                child: SizedBox(
                  child: Image.asset("assets/images/not_found.png"),
                ),
              )
            : Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 220,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
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
                      child: _selectedCourseVideo.isEmpty
                          ? Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.play_circle_outline,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Select a video to play',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : YoutubePlayerBuilder(
                              player: YoutubePlayer(
                                controller: _controller,
                                showVideoProgressIndicator: true,
                                progressIndicatorColor: Colors.red,
                                progressColors: const ProgressBarColors(
                                  playedColor: Colors.red,
                                  handleColor: Colors.redAccent,
                                ),
                              ),
                              builder: (context, player) => player,
                            ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: ExpansionPanelList(
                          animationDuration: const Duration(milliseconds: 1000),
                          dividerColor: appTheme.primary.withOpacity(.4),
                          elevation: 1,
                          expandedHeaderPadding: EdgeInsets.zero,
                          expansionCallback: (int index, bool isExpanded) {
                            // Handle expansion state
                            setState(() {
                              _isCourseExpanded[index] =
                                  !_isCourseExpanded[index];
                            });
                          },
                          children: [
                            for (int index = 0; index < courses.length; index++)
                              ExpansionPanel(
                                //  key: UniqueKey(),
                                backgroundColor: appTheme.scaffold,
                                headerBuilder: (context, isExpanded) =>
                                    Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 18),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Section ${index + 1}: ${courses[index]['name']}",
                                        style: textTheme.headlineMedium,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "$_selectedVideoIndex / ${courses[index]['sessions'].length}",
                                        style: textTheme.labelSmall,
                                      ),
                                    ],
                                  ),
                                ),
                                body: ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  physics: const BouncingScrollPhysics(),
                                  separatorBuilder: (context, index) =>
                                      const Divider(),
                                  shrinkWrap: true,
                                  itemCount: courses[index]['sessions'].length,
                                  itemBuilder: (context, itemIndex) =>
                                      GestureDetector(
                                    onTap: () {
                                      // setState(() {
                                      //   // Toggle the expansion state
                                      //   _isCourseExpanded[index] =
                                      //       !_isCourseExpanded[index];
                                      // });

                                      print(index);
                                      playCourse(courses[index]['sessions']
                                          [itemIndex]['video']);
                                      _selectedVideoIndex = courses[index]
                                              ['sessions'][itemIndex]
                                          .indexOf(_selectedCourseVideo);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.zero,
                                      child: Column(
                                        children: [
                                          ListTile(
                                            minLeadingWidth: 0,
                                            contentPadding: EdgeInsets.zero,
                                            leading: Checkbox(
                                              value: false,
                                              onChanged: (val) => {},
                                            ),
                                            title: Text(
                                              "${itemIndex + 1}. ${courses[index]['sessions'][itemIndex]['name']}",
                                              style: textTheme.labelMedium,
                                            ),
                                            subtitle: Row(
                                              children: [
                                                const Icon(
                                                  CupertinoIcons.play_rectangle,
                                                  size: 15,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  courses[index]["sessions"]
                                                          [itemIndex]["time"] ??
                                                      "",
                                                  style: textTheme.labelMedium,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                isExpanded: _isCourseExpanded[index],
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
