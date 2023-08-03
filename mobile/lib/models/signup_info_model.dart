class SignUpInfo {
  String email;
  String otp;
  String fullname;
  String birthday;
  String password;

  SignUpInfo(
      {this.email = '',
      this.otp = '',
      this.fullname = '',
      this.password = '',
      this.birthday = ''});

  String? get name => null;
}
