class AuthStatus {
  final String accessToken;
  final String tokenType;
  final bool is2faConfiguredByUser;
  final bool is2faVerifiedByUser;
  final bool isEmailVerificationRequired;

  AuthStatus({
    required this.accessToken,
    required this.tokenType,
    required this.is2faConfiguredByUser,
    required this.is2faVerifiedByUser,
    required this.isEmailVerificationRequired,
  });

  factory AuthStatus.fromJson(Map<String, dynamic> json) {
    return AuthStatus(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      is2faConfiguredByUser: json['is_2fa_configured_by_user'] as bool,
      is2faVerifiedByUser: json['is_2fa_verified_by_user'] as bool,
      isEmailVerificationRequired: json['is_email_verification_required'] as bool,
    );
  }
}