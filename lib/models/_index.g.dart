// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_index.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
      name: json['name'] as String,
      email: json['email'] as String,
      id: (json['id'] as num).toInt(),
      role: $enumDecode(_$RoleEnumMap, json['role']),
      profile: UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
      profileImage: json['profile_image'] as String?,
      experience: (json['experience'] as List<dynamic>?)
          ?.map((e) => Experience.fromJson(e as Map<String, dynamic>))
          .toList(),
      resume:
          (json['resume'] as List<dynamic>?)?.map((e) => e as String).toList(),
      skills: (json['skills'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      education: (json['education'] as List<dynamic>?)
          ?.map((e) => Education.fromJson(e as Map<String, dynamic>))
          .toList(),
      llmInsights: json['llm_insights'] == null
          ? null
          : LLMInsights.fromJson(json['llm_insights'] as Map<String, dynamic>),
      bookmarkCount: (json['bookmark_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'id': instance.id,
      'role': _$RoleEnumMap[instance.role]!,
      'profile': instance.profile,
      'profile_image': instance.profileImage,
      'experience': instance.experience,
      'resume': instance.resume,
      'skills': instance.skills,
      'education': instance.education,
      'llm_insights': instance.llmInsights,
      'bookmark_count': instance.bookmarkCount,
    };

const _$RoleEnumMap = {
  Role.JOB_SEEKER: 'JOB_SEEKER',
  Role.EMPLOYER: 'EMPLOYER',
  Role.ADMIN: 'ADMIN',
  Role.CREATOR: 'CREATOR',
};

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
      about: json['about'] as String?,
      portfolio: json['portfolio'] as String?,
      created: DateTime.parse(json['created'] as String),
      updated: json['updated'] == null
          ? null
          : DateTime.parse(json['updated'] as String),
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      location: json['location'] as String?,
    );

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'about': instance.about,
      'portfolio': instance.portfolio,
      'created': instance.created.toIso8601String(),
      'updated': instance.updated?.toIso8601String(),
      'languages': instance.languages,
      'location': instance.location,
    };

_Skills _$SkillsFromJson(Map<String, dynamic> json) => _Skills(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$SkillsToJson(_Skills instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

_Experience _$ExperienceFromJson(Map<String, dynamic> json) => _Experience(
      id: (json['id'] as num).toInt(),
      companyName: json['company_name'] as String,
      jobTitle: json['job_title'] as String,
      startDate: json['start_date'] as String,
      tasks: json['tasks'] as String?,
      endDate: json['end_date'] as String?,
      isRemote: json['is_remote'] as bool?,
      hasCompleted: json['has_completed'] as bool?,
    );

Map<String, dynamic> _$ExperienceToJson(_Experience instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company_name': instance.companyName,
      'job_title': instance.jobTitle,
      'start_date': instance.startDate,
      'tasks': instance.tasks,
      'end_date': instance.endDate,
      'is_remote': instance.isRemote,
      'has_completed': instance.hasCompleted,
    };

_Education _$EducationFromJson(Map<String, dynamic> json) => _Education(
      id: (json['id'] as num).toInt(),
      program: json['program'] as String,
      institution: json['institution'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String?,
      hasCompleted: json['has_completed'] as bool?,
    );

Map<String, dynamic> _$EducationToJson(_Education instance) =>
    <String, dynamic>{
      'id': instance.id,
      'program': instance.program,
      'institution': instance.institution,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'has_completed': instance.hasCompleted,
    };

_LLMInsights _$LLMInsightsFromJson(Map<String, dynamic> json) => _LLMInsights(
      careerStage: json['career_stage'] as String?,
      primaryDomain: json['primary_domain'] as String?,
      yearsExperience: (json['years_experience'] as num?)?.toInt(),
      keyStrengths: (json['key_strengths'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      growthAreas: (json['growth_areas'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      recommendedRoles: (json['recommended_roles'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$LLMInsightsToJson(_LLMInsights instance) =>
    <String, dynamic>{
      'career_stage': instance.careerStage,
      'primary_domain': instance.primaryDomain,
      'years_experience': instance.yearsExperience,
      'key_strengths': instance.keyStrengths,
      'growth_areas': instance.growthAreas,
      'recommended_roles': instance.recommendedRoles,
    };
