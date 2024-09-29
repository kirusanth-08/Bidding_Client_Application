class LoginData {
  String email;
  String password;
  bool isFirstTimeEnabled;
  String? newPassword;
  String? confirmPassword;

  LoginData({
    required this.email,
    required this.password,
    required this.isFirstTimeEnabled,
    this.newPassword,
    this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'isFirstTimeEnabled': isFirstTimeEnabled,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }
}
