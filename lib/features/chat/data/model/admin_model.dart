class AdminModel {
  final String id;
  final String name;
  final String profileImage;

  AdminModel({
    required this.id,
    required this.name,
    this.profileImage = '',
  });

  factory AdminModel.fromMap(Map<String, dynamic> map, String id) {
    return AdminModel(
      id: id,
      name: map['name'] ?? 'Admin',
      profileImage: map['profileImage'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'profileImage': profileImage,
    };
  }
}