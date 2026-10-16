/// Regions the Cloud Functions are deployed to (see `functions/index.js`).
/// A callable invoked in the wrong region fails with `NOT_FOUND`.
abstract final class FunctionRegions {
  /// `callGemini`, `searchFood`, `deleteAccount`, `getCallConfig`,
  /// `notifyNewSession`.
  static const String general = 'us-central1';

  /// `removeCoach`, deployed alongside the Firestore triggers.
  static const String coaching = 'asia-south1';
}
