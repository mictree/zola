import 'package:flutter/material.dart';
import 'package:zola/services/otp.dart' as otp_service;
import 'package:zola/widgets/password_textfield.dart';

class PasswordBottomSheet {
  static void showResetPasswordBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        isScrollControlled: true,
        builder: (BuildContext context) {
          return const ResetPasswordPage();
        });
  }
}

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  int currentPage = 0;
  late List<Widget> pages;
  late String email;
  late String otp;
  late String newPassword;
  late String retypeNewPassword;
  String accessToken = "";
  bool isPasswordVisible = false;

  void buildPage(BuildContext context) {
    setState(() {
      pages = [
        emailPage(context),
        otpPage(context),
        newPasswordPage(context),
      ];
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    buildPage(context);
    return pages[currentPage];
  }

  Widget emailPage(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            // padding: EdgeInsets.only(
            //     bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 16,
                ),
                const Center(
                  child: Text(
                    'Quên mật khẩu?',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    //  check here: https://stackoverflow.com/questions/53869078/how-to-move-bottomsheet-along-with-keyboard-which-has-textfieldautofocused-is-t
                    key: const Key("EMAIL_RESET_PASSWORD"),
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: const Text('Reset mật khẩu'),
                    onPressed: () async {
                      // Handle resetting password here
                      try {
                        await otp_service.requestOtpResetPassword(email);
                        setState(() {
                          currentPage = 1;
                        });
                      } catch (e) {
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Có lỗi xảy ra, vui lòng thử lại sau!'),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget otpPage(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            // padding: EdgeInsets.only(
            // bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 16,
                ),
                const Center(
                  child: Text(
                    'Nhập mã OTP',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    //  check here: https://stackoverflow.com/questions/53869078/how-to-move-bottomsheet-along-with-keyboard-which-has-textfieldautofocused-is-t
                    onChanged: (value) => setState(() {
                      otp = value;
                    }),
                    key: const Key("OTP_RESET_PASSWORD"),
                    decoration: const InputDecoration(
                      labelText: 'OTP',
                      hintText: '000000',
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: const Text('Tiếp tục'),
                    onPressed: () async {
                      // Handle resetting password here
                      try {
                        String token = await otp_service.verifyOtp(email, otp);
                        setState(() {
                          accessToken = token;
                          currentPage = 2;
                        });
                      } catch (e) {
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Có lỗi xảy ra, vui lòng thử lại sau!'),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget newPasswordPage(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            // padding: EdgeInsets.only(
            // bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 16,
                ),
                const Center(
                  child: Text(
                    'Nhập mật khẩu',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PasswordTextField(
                    key: const Key("NEW_PASSWORD_RESET_PASSWORD"),
                    hintText: 'Mật khẩu mới',
                    labelText: 'Mật khẩu mới',
                    onChanged: (value) => setState(() {
                      newPassword = value;
                    }),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PasswordTextField(
                      key: const Key("RETYPE_NEW_PASSWORD_RESET_PASSWORD"),
                      hintText: "Xác nhận mật khẩu",
                      labelText: "Xác nhận mật khẩu",
                      onChanged: (value) => setState(() {
                        retypeNewPassword = value;
                      }),
                    )),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: const Text('Hoàn thành'),
                    onPressed: () async {
                      try {
                        if (newPassword != retypeNewPassword) {
                          throw Exception("Password not match");
                        }
                        await otp_service.resetPassword(
                            accessToken, newPassword);

                        // Show success message
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đổi mật khẩu thành công!'),
                            ),
                          );
                          // sleep 2 s to close bottom sheet
                        }
                        await Future.delayed(const Duration(seconds: 2));
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
                      }
                      // Handle resetting password here
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
