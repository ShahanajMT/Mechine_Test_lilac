class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime sentAt;
  final String chatThreadId;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.sentAt,
    required this.chatThreadId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      senderId: json['sender_id'].toString(),
      receiverId: json['receiver_id'].toString(),
      text: json['message'] as String,
      sentAt: DateTime.parse(json['sent_at'] as String),
      chatThreadId: json['chat_thread_id'].toString(),
    );
  }
}