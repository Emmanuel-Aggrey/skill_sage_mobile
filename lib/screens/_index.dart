library;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import 'package:skill_sage_app/models/_index.dart';
import 'package:skill_sage_app/utils/_index.dart';
import 'package:skill_sage_app/providers/_index.dart';
import 'package:skill_sage_app/widgets/_index.dart';

part 'home.dart';
part 'onboarding_profile.dart';
part 'loader.dart';
part 'settings.dart';
part 'profile.dart';
part 'bookmark.dart';
part 'job_posts.dart';
part 'course_detail.dart';
part 'course_content.dart';
part 'courses.dart';
part 'filter.dart';
part 'notification.dart';
part 'external_jobs_screen.dart';
part 'webview_screen.dart';
part 'youtube_videos.dart';
part 'youtube_video_player_screen.dart';
part 'job_detail_analysis.dart';
part 'auth/login.dart';
part 'auth/register.dart';
part 'profile/edit_about.dart';
part 'profile/experience.dart';
part 'profile/edit_skills.dart';
part 'profile/edit_language.dart';
part 'profile/edit_profile.dart';
part 'profile/education.dart';

void showToast(BuildContext context, String message) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: CustomTextTheme.customTextTheme(context).textTheme.labelSmall,
      ),
      backgroundColor: AppTheme.appTheme(context).primary,
    ),
  );
}
