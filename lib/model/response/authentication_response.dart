class AuthenticationResponse {
  final String accessToken;
  final String refreshToken;
  final User user;

  AuthenticationResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) {
    return AuthenticationResponse(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final String id;

  User({
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
    );
  }
}
