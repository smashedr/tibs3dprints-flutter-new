class LoginSession {
  static final LoginSession _instance = LoginSession._internal();
  factory LoginSession() => _instance;
  LoginSession._internal();

  String? email;
  String? stateToken;
}
