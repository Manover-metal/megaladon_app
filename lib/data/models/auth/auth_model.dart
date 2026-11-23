class AuthModel {
  AuthModel({
    required this.token,
    this.refreshToken,
  });

  final String? token;

  /// Одноразовый: каждый /auth/refresh выдаёт новую пару. null — сессия
  /// старой версии приложения с вечным токеном, её меняют через
  /// /auth/upgrade-token (см. AuthBloc._initial).
  final String? refreshToken;

  /// Ключи те же, что в ответе API, поэтому один разбор и для ответа, и для
  /// сохранённой копии.
  static AuthModel fromJson(Map<String, dynamic> json) => AuthModel(
        token: json['token'] as String,
        refreshToken: json['refresh_token'] as String?,
      );

  AuthModel copyWith({
    String? token,
    String? refreshToken,
  }) =>
      AuthModel(
        token: token ?? this.token,
        refreshToken: refreshToken ?? this.refreshToken,
      );

  Map<String, dynamic> toJson() => {
        'token': token,
        'refresh_token': refreshToken,
      };
}
