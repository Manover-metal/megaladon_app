class AuthModel {
  AuthModel({
    required this.token,
  });

  final String? token;

  static AuthModel fromJson(Map<String, dynamic> json) => AuthModel(
        token: json['token'] as String,
      );

  AuthModel copyWith({
    String? token,
  }) =>
      AuthModel(
        token: token ?? this.token,
      );

  Map<String, dynamic> toJson() => {
        'token': token,
      };
}
