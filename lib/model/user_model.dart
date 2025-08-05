// class User {
//   final String id;
//   final String name;
//   final String email;
//   final String profilePhotoUrl;

//   User({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.profilePhotoUrl,
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'],
//       name: json['name'],
//       email: json['email'],
//       profilePhotoUrl: json['profile_photo_url'],
//     );
//   }
// }

import 'package:fliq/model/authStatus.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String profilePhotoUrl;
  final AuthStatus? authStatus;
  final String? messageReceivedFromPartnerAt;
  final bool? isOnline;
  final String? lastActiveAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePhotoUrl,
    this.authStatus,
    this.messageReceivedFromPartnerAt,
    this.isOnline,
    this.lastActiveAt,
  });

  // A factory for parsing the full JSON:API response after it has been decoded by Japx
  factory User.fromApi(Map<String, dynamic> json) {
    final authStatusData = json['auth_status'];
    final authStatus = authStatusData != null ? AuthStatus.fromJson(authStatusData) : null;
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profilePhotoUrl: json['profile_photo_url'] as String,
      authStatus: authStatus,
    );
  }

  // New factory for parsing the chat contacts response
  factory User.fromChatContact(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profilePhotoUrl: json['profile_photo_url'] as String,
      messageReceivedFromPartnerAt: json['message_received_from_partner_at'] as String?,
      isOnline: json['is_online'] as bool?,
      lastActiveAt: json['last_active_at'] as String?,
    );
  }
  
  // New factory for parsing included users from chat messages response
  factory User.fromIncluded(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profilePhotoUrl: json['profile_photo_url'] as String,
      isOnline: json['is_online'] as bool?,
      lastActiveAt: json['last_active_at'] as String?,
    );
  }
}