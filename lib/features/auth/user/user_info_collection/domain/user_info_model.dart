class UserInfoModel {
  final String name;
  final String gender;
  final int age;
  final String goal;
  final double currentWeight;
  final double goalWeight;
  final double height;
  final String activityLevel;

  UserInfoModel({
    this.name = '',
    this.gender = '',
    this.age = 0,
    this.goal = '',
    this.currentWeight = 0,
    this.goalWeight = 0,
    this.height = 0,
    this.activityLevel = '',
  });

  UserInfoModel copyWith({
    String? name,
    String? gender,
    int? age,
    String? goal,
    double? currentWeight,
    double? goalWeight,
    double? height,
    String? activityLevel,
  }) {
    return UserInfoModel(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      goal: goal ?? this.goal,
      currentWeight: currentWeight ?? this.currentWeight,
      goalWeight: goalWeight ?? this.goalWeight,
      height: height ?? this.height,
      activityLevel: activityLevel ?? this.activityLevel,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gender': gender,
      'age': age,
      'goal': goal,
      'currentWeight': currentWeight,
      'goalWeight': goalWeight,
      'height': height,
      'activityLevel': activityLevel,
    };
  }

  factory UserInfoModel.fromMap(Map<String, dynamic> map) {
    return UserInfoModel(
      name: map['name'] ?? '',
      gender: map['gender'] ?? '',
      age: map['age'] ?? 0,
      goal: map['goal'] ?? '',
      currentWeight: (map['currentWeight'] ?? 0).toDouble(),
      goalWeight: (map['goalWeight'] ?? 0).toDouble(),
      height: (map['height'] ?? 0).toDouble(),
      activityLevel: map['activityLevel'] ?? '',
    );
  }
}
