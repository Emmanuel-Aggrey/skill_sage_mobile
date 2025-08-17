// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '_index.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {
  String get name;
  String get email;
  int get id;
  Role get role;
  UserProfile get profile;
  @JsonKey(name: "profile_image")
  String? get profileImage;
  List<Experience>? get experience;
  List<String>? get resume;
  List<Map>? get skills;
  List<Education>? get education;
  @JsonKey(name: "llm_insights")
  LLMInsights? get llmInsights;
  @JsonKey(name: "bookmark_count")
  int? get bookmarkCount;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserCopyWith<User> get copyWith =>
      _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is User &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            const DeepCollectionEquality()
                .equals(other.experience, experience) &&
            const DeepCollectionEquality().equals(other.resume, resume) &&
            const DeepCollectionEquality().equals(other.skills, skills) &&
            const DeepCollectionEquality().equals(other.education, education) &&
            (identical(other.llmInsights, llmInsights) ||
                other.llmInsights == llmInsights) &&
            (identical(other.bookmarkCount, bookmarkCount) ||
                other.bookmarkCount == bookmarkCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      email,
      id,
      role,
      profile,
      profileImage,
      const DeepCollectionEquality().hash(experience),
      const DeepCollectionEquality().hash(resume),
      const DeepCollectionEquality().hash(skills),
      const DeepCollectionEquality().hash(education),
      llmInsights,
      bookmarkCount);

  @override
  String toString() {
    return 'User(name: $name, email: $email, id: $id, role: $role, profile: $profile, profileImage: $profileImage, experience: $experience, resume: $resume, skills: $skills, education: $education, llmInsights: $llmInsights, bookmarkCount: $bookmarkCount)';
  }
}

/// @nodoc
abstract mixin class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) _then) =
      _$UserCopyWithImpl;
  @useResult
  $Res call(
      {String name,
      String email,
      int id,
      Role role,
      UserProfile profile,
      @JsonKey(name: "profile_image") String? profileImage,
      List<Experience>? experience,
      List<String>? resume,
      List<Map>? skills,
      List<Education>? education,
      @JsonKey(name: "llm_insights") LLMInsights? llmInsights,
      @JsonKey(name: "bookmark_count") int? bookmarkCount});

  $UserProfileCopyWith<$Res> get profile;
  $LLMInsightsCopyWith<$Res>? get llmInsights;
}

/// @nodoc
class _$UserCopyWithImpl<$Res> implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = null,
    Object? id = null,
    Object? role = null,
    Object? profile = null,
    Object? profileImage = freezed,
    Object? experience = freezed,
    Object? resume = freezed,
    Object? skills = freezed,
    Object? education = freezed,
    Object? llmInsights = freezed,
    Object? bookmarkCount = freezed,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as Role,
      profile: null == profile
          ? _self.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as UserProfile,
      profileImage: freezed == profileImage
          ? _self.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      experience: freezed == experience
          ? _self.experience
          : experience // ignore: cast_nullable_to_non_nullable
              as List<Experience>?,
      resume: freezed == resume
          ? _self.resume
          : resume // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      skills: freezed == skills
          ? _self.skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<Map>?,
      education: freezed == education
          ? _self.education
          : education // ignore: cast_nullable_to_non_nullable
              as List<Education>?,
      llmInsights: freezed == llmInsights
          ? _self.llmInsights
          : llmInsights // ignore: cast_nullable_to_non_nullable
              as LLMInsights?,
      bookmarkCount: freezed == bookmarkCount
          ? _self.bookmarkCount
          : bookmarkCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res> get profile {
    return $UserProfileCopyWith<$Res>(_self.profile, (value) {
      return _then(_self.copyWith(profile: value));
    });
  }

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LLMInsightsCopyWith<$Res>? get llmInsights {
    if (_self.llmInsights == null) {
      return null;
    }

    return $LLMInsightsCopyWith<$Res>(_self.llmInsights!, (value) {
      return _then(_self.copyWith(llmInsights: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _User implements User {
  const _User(
      {required this.name,
      required this.email,
      required this.id,
      required this.role,
      required this.profile,
      @JsonKey(name: "profile_image") this.profileImage,
      final List<Experience>? experience,
      final List<String>? resume,
      final List<Map>? skills,
      final List<Education>? education,
      @JsonKey(name: "llm_insights") this.llmInsights,
      @JsonKey(name: "bookmark_count") this.bookmarkCount})
      : _experience = experience,
        _resume = resume,
        _skills = skills,
        _education = education;
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @override
  final String name;
  @override
  final String email;
  @override
  final int id;
  @override
  final Role role;
  @override
  final UserProfile profile;
  @override
  @JsonKey(name: "profile_image")
  final String? profileImage;
  final List<Experience>? _experience;
  @override
  List<Experience>? get experience {
    final value = _experience;
    if (value == null) return null;
    if (_experience is EqualUnmodifiableListView) return _experience;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _resume;
  @override
  List<String>? get resume {
    final value = _resume;
    if (value == null) return null;
    if (_resume is EqualUnmodifiableListView) return _resume;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Map>? _skills;
  @override
  List<Map>? get skills {
    final value = _skills;
    if (value == null) return null;
    if (_skills is EqualUnmodifiableListView) return _skills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Education>? _education;
  @override
  List<Education>? get education {
    final value = _education;
    if (value == null) return null;
    if (_education is EqualUnmodifiableListView) return _education;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: "llm_insights")
  final LLMInsights? llmInsights;
  @override
  @JsonKey(name: "bookmark_count")
  final int? bookmarkCount;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserCopyWith<_User> get copyWith =>
      __$UserCopyWithImpl<_User>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _User &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            const DeepCollectionEquality()
                .equals(other._experience, _experience) &&
            const DeepCollectionEquality().equals(other._resume, _resume) &&
            const DeepCollectionEquality().equals(other._skills, _skills) &&
            const DeepCollectionEquality()
                .equals(other._education, _education) &&
            (identical(other.llmInsights, llmInsights) ||
                other.llmInsights == llmInsights) &&
            (identical(other.bookmarkCount, bookmarkCount) ||
                other.bookmarkCount == bookmarkCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      email,
      id,
      role,
      profile,
      profileImage,
      const DeepCollectionEquality().hash(_experience),
      const DeepCollectionEquality().hash(_resume),
      const DeepCollectionEquality().hash(_skills),
      const DeepCollectionEquality().hash(_education),
      llmInsights,
      bookmarkCount);

  @override
  String toString() {
    return 'User(name: $name, email: $email, id: $id, role: $role, profile: $profile, profileImage: $profileImage, experience: $experience, resume: $resume, skills: $skills, education: $education, llmInsights: $llmInsights, bookmarkCount: $bookmarkCount)';
  }
}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) =
      __$UserCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String name,
      String email,
      int id,
      Role role,
      UserProfile profile,
      @JsonKey(name: "profile_image") String? profileImage,
      List<Experience>? experience,
      List<String>? resume,
      List<Map>? skills,
      List<Education>? education,
      @JsonKey(name: "llm_insights") LLMInsights? llmInsights,
      @JsonKey(name: "bookmark_count") int? bookmarkCount});

  @override
  $UserProfileCopyWith<$Res> get profile;
  @override
  $LLMInsightsCopyWith<$Res>? get llmInsights;
}

/// @nodoc
class __$UserCopyWithImpl<$Res> implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? email = null,
    Object? id = null,
    Object? role = null,
    Object? profile = null,
    Object? profileImage = freezed,
    Object? experience = freezed,
    Object? resume = freezed,
    Object? skills = freezed,
    Object? education = freezed,
    Object? llmInsights = freezed,
    Object? bookmarkCount = freezed,
  }) {
    return _then(_User(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as Role,
      profile: null == profile
          ? _self.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as UserProfile,
      profileImage: freezed == profileImage
          ? _self.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      experience: freezed == experience
          ? _self._experience
          : experience // ignore: cast_nullable_to_non_nullable
              as List<Experience>?,
      resume: freezed == resume
          ? _self._resume
          : resume // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      skills: freezed == skills
          ? _self._skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<Map>?,
      education: freezed == education
          ? _self._education
          : education // ignore: cast_nullable_to_non_nullable
              as List<Education>?,
      llmInsights: freezed == llmInsights
          ? _self.llmInsights
          : llmInsights // ignore: cast_nullable_to_non_nullable
              as LLMInsights?,
      bookmarkCount: freezed == bookmarkCount
          ? _self.bookmarkCount
          : bookmarkCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res> get profile {
    return $UserProfileCopyWith<$Res>(_self.profile, (value) {
      return _then(_self.copyWith(profile: value));
    });
  }

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LLMInsightsCopyWith<$Res>? get llmInsights {
    if (_self.llmInsights == null) {
      return null;
    }

    return $LLMInsightsCopyWith<$Res>(_self.llmInsights!, (value) {
      return _then(_self.copyWith(llmInsights: value));
    });
  }
}

/// @nodoc
mixin _$UserProfile {
  String? get about;
  String? get portfolio;
  DateTime get created;
  DateTime? get updated;
  List<String>? get languages;
  String? get location;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<UserProfile> get copyWith =>
      _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserProfile &&
            (identical(other.about, about) || other.about == about) &&
            (identical(other.portfolio, portfolio) ||
                other.portfolio == portfolio) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.updated, updated) || other.updated == updated) &&
            const DeepCollectionEquality().equals(other.languages, languages) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, about, portfolio, created,
      updated, const DeepCollectionEquality().hash(languages), location);

  @override
  String toString() {
    return 'UserProfile(about: $about, portfolio: $portfolio, created: $created, updated: $updated, languages: $languages, location: $location)';
  }
}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) _then) =
      _$UserProfileCopyWithImpl;
  @useResult
  $Res call(
      {String? about,
      String? portfolio,
      DateTime created,
      DateTime? updated,
      List<String>? languages,
      String? location});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res> implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? about = freezed,
    Object? portfolio = freezed,
    Object? created = null,
    Object? updated = freezed,
    Object? languages = freezed,
    Object? location = freezed,
  }) {
    return _then(_self.copyWith(
      about: freezed == about
          ? _self.about
          : about // ignore: cast_nullable_to_non_nullable
              as String?,
      portfolio: freezed == portfolio
          ? _self.portfolio
          : portfolio // ignore: cast_nullable_to_non_nullable
              as String?,
      created: null == created
          ? _self.created
          : created // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updated: freezed == updated
          ? _self.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      languages: freezed == languages
          ? _self.languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      location: freezed == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _UserProfile implements UserProfile {
  const _UserProfile(
      {this.about,
      this.portfolio,
      required this.created,
      this.updated,
      final List<String>? languages,
      this.location})
      : _languages = languages;
  factory _UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  @override
  final String? about;
  @override
  final String? portfolio;
  @override
  final DateTime created;
  @override
  final DateTime? updated;
  final List<String>? _languages;
  @override
  List<String>? get languages {
    final value = _languages;
    if (value == null) return null;
    if (_languages is EqualUnmodifiableListView) return _languages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? location;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserProfileCopyWith<_UserProfile> get copyWith =>
      __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserProfileToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserProfile &&
            (identical(other.about, about) || other.about == about) &&
            (identical(other.portfolio, portfolio) ||
                other.portfolio == portfolio) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.updated, updated) || other.updated == updated) &&
            const DeepCollectionEquality()
                .equals(other._languages, _languages) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, about, portfolio, created,
      updated, const DeepCollectionEquality().hash(_languages), location);

  @override
  String toString() {
    return 'UserProfile(about: $about, portfolio: $portfolio, created: $created, updated: $updated, languages: $languages, location: $location)';
  }
}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(
          _UserProfile value, $Res Function(_UserProfile) _then) =
      __$UserProfileCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? about,
      String? portfolio,
      DateTime created,
      DateTime? updated,
      List<String>? languages,
      String? location});
}

/// @nodoc
class __$UserProfileCopyWithImpl<$Res> implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? about = freezed,
    Object? portfolio = freezed,
    Object? created = null,
    Object? updated = freezed,
    Object? languages = freezed,
    Object? location = freezed,
  }) {
    return _then(_UserProfile(
      about: freezed == about
          ? _self.about
          : about // ignore: cast_nullable_to_non_nullable
              as String?,
      portfolio: freezed == portfolio
          ? _self.portfolio
          : portfolio // ignore: cast_nullable_to_non_nullable
              as String?,
      created: null == created
          ? _self.created
          : created // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updated: freezed == updated
          ? _self.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      languages: freezed == languages
          ? _self._languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      location: freezed == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$Skills {
  int get id;
  String get name;

  /// Create a copy of Skills
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SkillsCopyWith<Skills> get copyWith =>
      _$SkillsCopyWithImpl<Skills>(this as Skills, _$identity);

  /// Serializes this Skills to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Skills &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @override
  String toString() {
    return 'Skills(id: $id, name: $name)';
  }
}

/// @nodoc
abstract mixin class $SkillsCopyWith<$Res> {
  factory $SkillsCopyWith(Skills value, $Res Function(Skills) _then) =
      _$SkillsCopyWithImpl;
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class _$SkillsCopyWithImpl<$Res> implements $SkillsCopyWith<$Res> {
  _$SkillsCopyWithImpl(this._self, this._then);

  final Skills _self;
  final $Res Function(Skills) _then;

  /// Create a copy of Skills
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Skills implements Skills {
  const _Skills({required this.id, required this.name});
  factory _Skills.fromJson(Map<String, dynamic> json) => _$SkillsFromJson(json);

  @override
  final int id;
  @override
  final String name;

  /// Create a copy of Skills
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SkillsCopyWith<_Skills> get copyWith =>
      __$SkillsCopyWithImpl<_Skills>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SkillsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Skills &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @override
  String toString() {
    return 'Skills(id: $id, name: $name)';
  }
}

/// @nodoc
abstract mixin class _$SkillsCopyWith<$Res> implements $SkillsCopyWith<$Res> {
  factory _$SkillsCopyWith(_Skills value, $Res Function(_Skills) _then) =
      __$SkillsCopyWithImpl;
  @override
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class __$SkillsCopyWithImpl<$Res> implements _$SkillsCopyWith<$Res> {
  __$SkillsCopyWithImpl(this._self, this._then);

  final _Skills _self;
  final $Res Function(_Skills) _then;

  /// Create a copy of Skills
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_Skills(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$Experience {
  int get id;
  @JsonKey(name: "company_name")
  String get companyName;
  @JsonKey(name: "job_title")
  String get jobTitle;
  @JsonKey(name: "start_date")
  String get startDate;
  String? get tasks;
  @JsonKey(name: "end_date")
  String? get endDate;
  @JsonKey(name: "is_remote")
  bool? get isRemote;
  @JsonKey(name: "has_completed")
  bool? get hasCompleted;

  /// Create a copy of Experience
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExperienceCopyWith<Experience> get copyWith =>
      _$ExperienceCopyWithImpl<Experience>(this as Experience, _$identity);

  /// Serializes this Experience to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Experience &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.jobTitle, jobTitle) ||
                other.jobTitle == jobTitle) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.tasks, tasks) || other.tasks == tasks) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isRemote, isRemote) ||
                other.isRemote == isRemote) &&
            (identical(other.hasCompleted, hasCompleted) ||
                other.hasCompleted == hasCompleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, companyName, jobTitle,
      startDate, tasks, endDate, isRemote, hasCompleted);

  @override
  String toString() {
    return 'Experience(id: $id, companyName: $companyName, jobTitle: $jobTitle, startDate: $startDate, tasks: $tasks, endDate: $endDate, isRemote: $isRemote, hasCompleted: $hasCompleted)';
  }
}

/// @nodoc
abstract mixin class $ExperienceCopyWith<$Res> {
  factory $ExperienceCopyWith(
          Experience value, $Res Function(Experience) _then) =
      _$ExperienceCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: "company_name") String companyName,
      @JsonKey(name: "job_title") String jobTitle,
      @JsonKey(name: "start_date") String startDate,
      String? tasks,
      @JsonKey(name: "end_date") String? endDate,
      @JsonKey(name: "is_remote") bool? isRemote,
      @JsonKey(name: "has_completed") bool? hasCompleted});
}

/// @nodoc
class _$ExperienceCopyWithImpl<$Res> implements $ExperienceCopyWith<$Res> {
  _$ExperienceCopyWithImpl(this._self, this._then);

  final Experience _self;
  final $Res Function(Experience) _then;

  /// Create a copy of Experience
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyName = null,
    Object? jobTitle = null,
    Object? startDate = null,
    Object? tasks = freezed,
    Object? endDate = freezed,
    Object? isRemote = freezed,
    Object? hasCompleted = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      companyName: null == companyName
          ? _self.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      jobTitle: null == jobTitle
          ? _self.jobTitle
          : jobTitle // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      tasks: freezed == tasks
          ? _self.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as String?,
      endDate: freezed == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String?,
      isRemote: freezed == isRemote
          ? _self.isRemote
          : isRemote // ignore: cast_nullable_to_non_nullable
              as bool?,
      hasCompleted: freezed == hasCompleted
          ? _self.hasCompleted
          : hasCompleted // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Experience implements Experience {
  const _Experience(
      {required this.id,
      @JsonKey(name: "company_name") required this.companyName,
      @JsonKey(name: "job_title") required this.jobTitle,
      @JsonKey(name: "start_date") required this.startDate,
      this.tasks,
      @JsonKey(name: "end_date") this.endDate,
      @JsonKey(name: "is_remote") this.isRemote,
      @JsonKey(name: "has_completed") this.hasCompleted});
  factory _Experience.fromJson(Map<String, dynamic> json) =>
      _$ExperienceFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: "company_name")
  final String companyName;
  @override
  @JsonKey(name: "job_title")
  final String jobTitle;
  @override
  @JsonKey(name: "start_date")
  final String startDate;
  @override
  final String? tasks;
  @override
  @JsonKey(name: "end_date")
  final String? endDate;
  @override
  @JsonKey(name: "is_remote")
  final bool? isRemote;
  @override
  @JsonKey(name: "has_completed")
  final bool? hasCompleted;

  /// Create a copy of Experience
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExperienceCopyWith<_Experience> get copyWith =>
      __$ExperienceCopyWithImpl<_Experience>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ExperienceToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Experience &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.jobTitle, jobTitle) ||
                other.jobTitle == jobTitle) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.tasks, tasks) || other.tasks == tasks) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isRemote, isRemote) ||
                other.isRemote == isRemote) &&
            (identical(other.hasCompleted, hasCompleted) ||
                other.hasCompleted == hasCompleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, companyName, jobTitle,
      startDate, tasks, endDate, isRemote, hasCompleted);

  @override
  String toString() {
    return 'Experience(id: $id, companyName: $companyName, jobTitle: $jobTitle, startDate: $startDate, tasks: $tasks, endDate: $endDate, isRemote: $isRemote, hasCompleted: $hasCompleted)';
  }
}

/// @nodoc
abstract mixin class _$ExperienceCopyWith<$Res>
    implements $ExperienceCopyWith<$Res> {
  factory _$ExperienceCopyWith(
          _Experience value, $Res Function(_Experience) _then) =
      __$ExperienceCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: "company_name") String companyName,
      @JsonKey(name: "job_title") String jobTitle,
      @JsonKey(name: "start_date") String startDate,
      String? tasks,
      @JsonKey(name: "end_date") String? endDate,
      @JsonKey(name: "is_remote") bool? isRemote,
      @JsonKey(name: "has_completed") bool? hasCompleted});
}

/// @nodoc
class __$ExperienceCopyWithImpl<$Res> implements _$ExperienceCopyWith<$Res> {
  __$ExperienceCopyWithImpl(this._self, this._then);

  final _Experience _self;
  final $Res Function(_Experience) _then;

  /// Create a copy of Experience
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? companyName = null,
    Object? jobTitle = null,
    Object? startDate = null,
    Object? tasks = freezed,
    Object? endDate = freezed,
    Object? isRemote = freezed,
    Object? hasCompleted = freezed,
  }) {
    return _then(_Experience(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      companyName: null == companyName
          ? _self.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      jobTitle: null == jobTitle
          ? _self.jobTitle
          : jobTitle // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      tasks: freezed == tasks
          ? _self.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as String?,
      endDate: freezed == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String?,
      isRemote: freezed == isRemote
          ? _self.isRemote
          : isRemote // ignore: cast_nullable_to_non_nullable
              as bool?,
      hasCompleted: freezed == hasCompleted
          ? _self.hasCompleted
          : hasCompleted // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
mixin _$Education {
  int get id;
  String get program;
  String get institution;
  @JsonKey(name: "start_date")
  String get startDate;
  @JsonKey(name: "end_date")
  String? get endDate;
  @JsonKey(name: "has_completed")
  bool? get hasCompleted;

  /// Create a copy of Education
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EducationCopyWith<Education> get copyWith =>
      _$EducationCopyWithImpl<Education>(this as Education, _$identity);

  /// Serializes this Education to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Education &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.program, program) || other.program == program) &&
            (identical(other.institution, institution) ||
                other.institution == institution) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.hasCompleted, hasCompleted) ||
                other.hasCompleted == hasCompleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, program, institution, startDate, endDate, hasCompleted);

  @override
  String toString() {
    return 'Education(id: $id, program: $program, institution: $institution, startDate: $startDate, endDate: $endDate, hasCompleted: $hasCompleted)';
  }
}

/// @nodoc
abstract mixin class $EducationCopyWith<$Res> {
  factory $EducationCopyWith(Education value, $Res Function(Education) _then) =
      _$EducationCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String program,
      String institution,
      @JsonKey(name: "start_date") String startDate,
      @JsonKey(name: "end_date") String? endDate,
      @JsonKey(name: "has_completed") bool? hasCompleted});
}

/// @nodoc
class _$EducationCopyWithImpl<$Res> implements $EducationCopyWith<$Res> {
  _$EducationCopyWithImpl(this._self, this._then);

  final Education _self;
  final $Res Function(Education) _then;

  /// Create a copy of Education
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? program = null,
    Object? institution = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? hasCompleted = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      program: null == program
          ? _self.program
          : program // ignore: cast_nullable_to_non_nullable
              as String,
      institution: null == institution
          ? _self.institution
          : institution // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: freezed == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String?,
      hasCompleted: freezed == hasCompleted
          ? _self.hasCompleted
          : hasCompleted // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Education implements Education {
  const _Education(
      {required this.id,
      required this.program,
      required this.institution,
      @JsonKey(name: "start_date") required this.startDate,
      @JsonKey(name: "end_date") this.endDate,
      @JsonKey(name: "has_completed") this.hasCompleted});
  factory _Education.fromJson(Map<String, dynamic> json) =>
      _$EducationFromJson(json);

  @override
  final int id;
  @override
  final String program;
  @override
  final String institution;
  @override
  @JsonKey(name: "start_date")
  final String startDate;
  @override
  @JsonKey(name: "end_date")
  final String? endDate;
  @override
  @JsonKey(name: "has_completed")
  final bool? hasCompleted;

  /// Create a copy of Education
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EducationCopyWith<_Education> get copyWith =>
      __$EducationCopyWithImpl<_Education>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EducationToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Education &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.program, program) || other.program == program) &&
            (identical(other.institution, institution) ||
                other.institution == institution) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.hasCompleted, hasCompleted) ||
                other.hasCompleted == hasCompleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, program, institution, startDate, endDate, hasCompleted);

  @override
  String toString() {
    return 'Education(id: $id, program: $program, institution: $institution, startDate: $startDate, endDate: $endDate, hasCompleted: $hasCompleted)';
  }
}

/// @nodoc
abstract mixin class _$EducationCopyWith<$Res>
    implements $EducationCopyWith<$Res> {
  factory _$EducationCopyWith(
          _Education value, $Res Function(_Education) _then) =
      __$EducationCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String program,
      String institution,
      @JsonKey(name: "start_date") String startDate,
      @JsonKey(name: "end_date") String? endDate,
      @JsonKey(name: "has_completed") bool? hasCompleted});
}

/// @nodoc
class __$EducationCopyWithImpl<$Res> implements _$EducationCopyWith<$Res> {
  __$EducationCopyWithImpl(this._self, this._then);

  final _Education _self;
  final $Res Function(_Education) _then;

  /// Create a copy of Education
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? program = null,
    Object? institution = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? hasCompleted = freezed,
  }) {
    return _then(_Education(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      program: null == program
          ? _self.program
          : program // ignore: cast_nullable_to_non_nullable
              as String,
      institution: null == institution
          ? _self.institution
          : institution // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: freezed == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String?,
      hasCompleted: freezed == hasCompleted
          ? _self.hasCompleted
          : hasCompleted // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
mixin _$LLMInsights {
  @JsonKey(name: "career_stage")
  String? get careerStage;
  @JsonKey(name: "primary_domain")
  String? get primaryDomain;
  @JsonKey(name: "years_experience")
  int? get yearsExperience;
  @JsonKey(name: "key_strengths")
  List<String>? get keyStrengths;
  @JsonKey(name: "growth_areas")
  List<String>? get growthAreas;
  @JsonKey(name: "recommended_roles")
  List<String>? get recommendedRoles;

  /// Create a copy of LLMInsights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LLMInsightsCopyWith<LLMInsights> get copyWith =>
      _$LLMInsightsCopyWithImpl<LLMInsights>(this as LLMInsights, _$identity);

  /// Serializes this LLMInsights to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LLMInsights &&
            (identical(other.careerStage, careerStage) ||
                other.careerStage == careerStage) &&
            (identical(other.primaryDomain, primaryDomain) ||
                other.primaryDomain == primaryDomain) &&
            (identical(other.yearsExperience, yearsExperience) ||
                other.yearsExperience == yearsExperience) &&
            const DeepCollectionEquality()
                .equals(other.keyStrengths, keyStrengths) &&
            const DeepCollectionEquality()
                .equals(other.growthAreas, growthAreas) &&
            const DeepCollectionEquality()
                .equals(other.recommendedRoles, recommendedRoles));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      careerStage,
      primaryDomain,
      yearsExperience,
      const DeepCollectionEquality().hash(keyStrengths),
      const DeepCollectionEquality().hash(growthAreas),
      const DeepCollectionEquality().hash(recommendedRoles));

  @override
  String toString() {
    return 'LLMInsights(careerStage: $careerStage, primaryDomain: $primaryDomain, yearsExperience: $yearsExperience, keyStrengths: $keyStrengths, growthAreas: $growthAreas, recommendedRoles: $recommendedRoles)';
  }
}

/// @nodoc
abstract mixin class $LLMInsightsCopyWith<$Res> {
  factory $LLMInsightsCopyWith(
          LLMInsights value, $Res Function(LLMInsights) _then) =
      _$LLMInsightsCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: "career_stage") String? careerStage,
      @JsonKey(name: "primary_domain") String? primaryDomain,
      @JsonKey(name: "years_experience") int? yearsExperience,
      @JsonKey(name: "key_strengths") List<String>? keyStrengths,
      @JsonKey(name: "growth_areas") List<String>? growthAreas,
      @JsonKey(name: "recommended_roles") List<String>? recommendedRoles});
}

/// @nodoc
class _$LLMInsightsCopyWithImpl<$Res> implements $LLMInsightsCopyWith<$Res> {
  _$LLMInsightsCopyWithImpl(this._self, this._then);

  final LLMInsights _self;
  final $Res Function(LLMInsights) _then;

  /// Create a copy of LLMInsights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? careerStage = freezed,
    Object? primaryDomain = freezed,
    Object? yearsExperience = freezed,
    Object? keyStrengths = freezed,
    Object? growthAreas = freezed,
    Object? recommendedRoles = freezed,
  }) {
    return _then(_self.copyWith(
      careerStage: freezed == careerStage
          ? _self.careerStage
          : careerStage // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryDomain: freezed == primaryDomain
          ? _self.primaryDomain
          : primaryDomain // ignore: cast_nullable_to_non_nullable
              as String?,
      yearsExperience: freezed == yearsExperience
          ? _self.yearsExperience
          : yearsExperience // ignore: cast_nullable_to_non_nullable
              as int?,
      keyStrengths: freezed == keyStrengths
          ? _self.keyStrengths
          : keyStrengths // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      growthAreas: freezed == growthAreas
          ? _self.growthAreas
          : growthAreas // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      recommendedRoles: freezed == recommendedRoles
          ? _self.recommendedRoles
          : recommendedRoles // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _LLMInsights implements LLMInsights {
  const _LLMInsights(
      {@JsonKey(name: "career_stage") this.careerStage,
      @JsonKey(name: "primary_domain") this.primaryDomain,
      @JsonKey(name: "years_experience") this.yearsExperience,
      @JsonKey(name: "key_strengths") final List<String>? keyStrengths,
      @JsonKey(name: "growth_areas") final List<String>? growthAreas,
      @JsonKey(name: "recommended_roles") final List<String>? recommendedRoles})
      : _keyStrengths = keyStrengths,
        _growthAreas = growthAreas,
        _recommendedRoles = recommendedRoles;
  factory _LLMInsights.fromJson(Map<String, dynamic> json) =>
      _$LLMInsightsFromJson(json);

  @override
  @JsonKey(name: "career_stage")
  final String? careerStage;
  @override
  @JsonKey(name: "primary_domain")
  final String? primaryDomain;
  @override
  @JsonKey(name: "years_experience")
  final int? yearsExperience;
  final List<String>? _keyStrengths;
  @override
  @JsonKey(name: "key_strengths")
  List<String>? get keyStrengths {
    final value = _keyStrengths;
    if (value == null) return null;
    if (_keyStrengths is EqualUnmodifiableListView) return _keyStrengths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _growthAreas;
  @override
  @JsonKey(name: "growth_areas")
  List<String>? get growthAreas {
    final value = _growthAreas;
    if (value == null) return null;
    if (_growthAreas is EqualUnmodifiableListView) return _growthAreas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _recommendedRoles;
  @override
  @JsonKey(name: "recommended_roles")
  List<String>? get recommendedRoles {
    final value = _recommendedRoles;
    if (value == null) return null;
    if (_recommendedRoles is EqualUnmodifiableListView)
      return _recommendedRoles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of LLMInsights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LLMInsightsCopyWith<_LLMInsights> get copyWith =>
      __$LLMInsightsCopyWithImpl<_LLMInsights>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LLMInsightsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LLMInsights &&
            (identical(other.careerStage, careerStage) ||
                other.careerStage == careerStage) &&
            (identical(other.primaryDomain, primaryDomain) ||
                other.primaryDomain == primaryDomain) &&
            (identical(other.yearsExperience, yearsExperience) ||
                other.yearsExperience == yearsExperience) &&
            const DeepCollectionEquality()
                .equals(other._keyStrengths, _keyStrengths) &&
            const DeepCollectionEquality()
                .equals(other._growthAreas, _growthAreas) &&
            const DeepCollectionEquality()
                .equals(other._recommendedRoles, _recommendedRoles));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      careerStage,
      primaryDomain,
      yearsExperience,
      const DeepCollectionEquality().hash(_keyStrengths),
      const DeepCollectionEquality().hash(_growthAreas),
      const DeepCollectionEquality().hash(_recommendedRoles));

  @override
  String toString() {
    return 'LLMInsights(careerStage: $careerStage, primaryDomain: $primaryDomain, yearsExperience: $yearsExperience, keyStrengths: $keyStrengths, growthAreas: $growthAreas, recommendedRoles: $recommendedRoles)';
  }
}

/// @nodoc
abstract mixin class _$LLMInsightsCopyWith<$Res>
    implements $LLMInsightsCopyWith<$Res> {
  factory _$LLMInsightsCopyWith(
          _LLMInsights value, $Res Function(_LLMInsights) _then) =
      __$LLMInsightsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "career_stage") String? careerStage,
      @JsonKey(name: "primary_domain") String? primaryDomain,
      @JsonKey(name: "years_experience") int? yearsExperience,
      @JsonKey(name: "key_strengths") List<String>? keyStrengths,
      @JsonKey(name: "growth_areas") List<String>? growthAreas,
      @JsonKey(name: "recommended_roles") List<String>? recommendedRoles});
}

/// @nodoc
class __$LLMInsightsCopyWithImpl<$Res> implements _$LLMInsightsCopyWith<$Res> {
  __$LLMInsightsCopyWithImpl(this._self, this._then);

  final _LLMInsights _self;
  final $Res Function(_LLMInsights) _then;

  /// Create a copy of LLMInsights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? careerStage = freezed,
    Object? primaryDomain = freezed,
    Object? yearsExperience = freezed,
    Object? keyStrengths = freezed,
    Object? growthAreas = freezed,
    Object? recommendedRoles = freezed,
  }) {
    return _then(_LLMInsights(
      careerStage: freezed == careerStage
          ? _self.careerStage
          : careerStage // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryDomain: freezed == primaryDomain
          ? _self.primaryDomain
          : primaryDomain // ignore: cast_nullable_to_non_nullable
              as String?,
      yearsExperience: freezed == yearsExperience
          ? _self.yearsExperience
          : yearsExperience // ignore: cast_nullable_to_non_nullable
              as int?,
      keyStrengths: freezed == keyStrengths
          ? _self._keyStrengths
          : keyStrengths // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      growthAreas: freezed == growthAreas
          ? _self._growthAreas
          : growthAreas // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      recommendedRoles: freezed == recommendedRoles
          ? _self._recommendedRoles
          : recommendedRoles // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

// dart format on
