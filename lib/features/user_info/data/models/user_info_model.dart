class UserInfoModel {
  final String uid;
  final String name;
  final String gender;
  final int age;
  final String goal;
  final double currentWeight;
  final double goalWeight;
  final double height;
  final String activityLevel;
  final int? timeDurationWeeks;
  final String? profileImageUrl;
  final bool hasPaid;
  final String? dietPreference;
  final Map<String, bool>? allergies;
  final String? otherAllergy;
  final Map<String, bool>? cuisines;
  final double? waterGoal;
  final double? stepsGoal;
  final double? sleepGoal;
  final String? email;

  UserInfoModel({
    this.uid = '',
    this.name = '',
    this.gender = '',
    this.age = 0,
    this.goal = '',
    this.currentWeight = 0,
    this.goalWeight = 0,
    this.height = 0,
    this.activityLevel = '',
    this.timeDurationWeeks,
    this.profileImageUrl,
    this.hasPaid = false,
    this.dietPreference,
    this.allergies,
    this.otherAllergy,
    this.cuisines,
    this.waterGoal,
    this.stepsGoal,
    this.sleepGoal,
    this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'gender': gender,
      'age': age,
      'goal': goal,
      'currentWeight': currentWeight,
      'goalWeight': goalWeight,
      'height': height,
      'activityLevel': activityLevel,
      'timeDurationWeeks': timeDurationWeeks,
      'profileImageUrl': profileImageUrl,
      'hasPaid': hasPaid,
      'dietPreference': dietPreference,
      'allergies': allergies,
      'otherAllergy': otherAllergy,
      'cuisines': cuisines,
      'waterGoal': waterGoal,
      'stepsGoal': stepsGoal,
      'sleepGoal': sleepGoal,
      'email': email,
    }..removeWhere((key, value) => value == null);
  }

  factory UserInfoModel.fromMap(Map<String, dynamic> map) {
    return UserInfoModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      gender: map['gender'] ?? '',
      age: map['age'] ?? 0,
      goal: map['goal'] ?? '',
      currentWeight: (map['currentWeight'] ?? 0).toDouble(),
      goalWeight: (map['goalWeight'] ?? 0).toDouble(),
      height: (map['height'] ?? 0).toDouble(),
      activityLevel: map['activityLevel'] ?? '',
      timeDurationWeeks: map['timeDurationWeeks'],
      profileImageUrl: map['profileImageUrl'],
      hasPaid: map['hasPaid'] ?? false,
      dietPreference: map['dietPreference'],
      allergies: map['allergies'] != null ? Map<String, bool>.from(map['allergies']) : null,
      otherAllergy: map['otherAllergy'],
      cuisines: map['cuisines'] != null ? Map<String, bool>.from(map['cuisines']) : null,
      waterGoal: (map['waterGoal'] as num?)?.toDouble(),
      stepsGoal: (map['stepsGoal'] as num?)?.toDouble(),
      sleepGoal: (map['sleepGoal'] as num?)?.toDouble(),
      email: map['email'],
    );
  }

  UserInfoModel copyWith({
    String? uid,
    String? name,
    String? gender,
    int? age,
    String? goal,
    double? currentWeight,
    double? goalWeight,
    double? height,
    String? activityLevel,
    int? timeDurationWeeks,
    String? profileImageUrl,
    bool? hasPaid,
    String? dietPreference,
    Map<String, bool>? allergies,
    String? otherAllergy,
    Map<String, bool>? cuisines,
    double? waterGoal,
    double? stepsGoal,
    double? sleepGoal,
    String? email,
  }) {
    return UserInfoModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      goal: goal ?? this.goal,
      currentWeight: currentWeight ?? this.currentWeight,
      goalWeight: goalWeight ?? this.goalWeight,
      height: height ?? this.height,
      activityLevel: activityLevel ?? this.activityLevel,
      timeDurationWeeks: timeDurationWeeks ?? this.timeDurationWeeks,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      hasPaid: hasPaid ?? this.hasPaid,
      dietPreference: dietPreference ?? this.dietPreference,
      allergies: allergies ?? this.allergies,
      otherAllergy: otherAllergy ?? this.otherAllergy,
      cuisines: cuisines ?? this.cuisines,
      waterGoal: waterGoal ?? this.waterGoal,
      stepsGoal: stepsGoal ?? this.stepsGoal,
      sleepGoal: sleepGoal ?? this.sleepGoal,
      email: email ?? this.email,
    );
  }
}