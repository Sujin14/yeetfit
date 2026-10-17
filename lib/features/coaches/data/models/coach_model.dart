import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/coach.dart';

/// Maps a `coaches/{uid}` document. Every field is read defensively because
/// the documents are written by a separate app (YeetCoach).
class CoachModel extends Coach {
  const CoachModel({
    required super.uid,
    required super.name,
    required super.bio,
    required super.profileImageUrl,
    required super.specializations,
    required super.certifications,
    required super.isVerified,
    super.averageRating = 0,
    super.ratingCount = 0,
  });

  factory CoachModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    final imageUrl = (data['profileImageUrl'] as String?)?.trim();
    return CoachModel(
      uid: doc.id,
      name: (data['name'] as String?)?.trim() ?? '',
      bio: (data['bio'] as String?)?.trim() ?? '',
      profileImageUrl: imageUrl == null || imageUrl.isEmpty ? null : imageUrl,
      specializations: _stringList(data['specializations']),
      certifications: _stringList(data['certifications']),
      isVerified: data['isVerified'] as bool? ?? false,
      averageRating: ((data['averageRating'] as num?) ?? 0).toDouble(),
      ratingCount: ((data['ratingCount'] as num?) ?? 0).toInt(),
    );
  }

  /// Accepts a list of strings, or of maps with a `name` or `title` key.
  static List<String> _stringList(Object? value) {
    if (value is! List) return const [];
    return [
      for (final item in value)
        if (_label(item) case final label? when label.isNotEmpty) label,
    ];
  }

  static String? _label(Object? item) => switch (item) {
    String() => item.trim(),
    Map() => ((item['name'] ?? item['title']) as String?)?.trim(),
    _ => null,
  };
}
