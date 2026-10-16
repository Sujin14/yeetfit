enum CallType {
  audio,
  video;

  bool get isVideo => this == video;
}
