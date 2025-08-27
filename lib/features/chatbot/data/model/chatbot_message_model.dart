class ChatbotMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatbotMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  factory ChatbotMessage.fromJson(Map<String, dynamic> json) {
    return ChatbotMessage(
      text: json['text'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}