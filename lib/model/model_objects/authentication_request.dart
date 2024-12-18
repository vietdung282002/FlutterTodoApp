class AuthenticationRequest {
  final String email;
  final String password;

  AuthenticationRequest({
    required this.email,
    required this.password,
  });

  factory AuthenticationRequest.fromJson(Map<String, dynamic> json) {
    return AuthenticationRequest(
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
