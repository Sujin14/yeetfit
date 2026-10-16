/// A coach profile from the top-level `coaches` collection, written by the
/// YeetCoach app. `isVerified` is set server-side only.
class Coach {
  final String uid;
  final String name;
  final String bio;
  final String? profileImageUrl;
  final List<String> specializations;
  final List<String> certifications;
  final bool isVerified;

  const Coach({
    required this.uid,
    required this.name,
    required this.bio,
    required this.profileImageUrl,
    required this.specializations,
    required this.certifications,
    required this.isVerified,
  });

  /// Case-insensitive match on name, bio or any specialization.
  bool matches(String query) {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) return true;
    return name.toLowerCase().contains(needle) ||
        bio.toLowerCase().contains(needle) ||
        specializations.any((tag) => tag.toLowerCase().contains(needle));
  }
}
