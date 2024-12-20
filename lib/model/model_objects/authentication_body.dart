class AuthenticationBody {
  final String email;
  final String password;

  AuthenticationBody({
    required this.email,
    required this.password,
  });

  factory AuthenticationBody.fromJson(Map<String, dynamic> json) {
    return AuthenticationBody(
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
