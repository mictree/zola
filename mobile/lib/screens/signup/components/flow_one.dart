import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:email_validator/email_validator.dart';

import 'package:zola/constants/route.dart';
import 'package:zola/screens/login/login_screen.dart';
import 'package:zola/widgets/my_button.dart';
import 'package:zola/controller/flow_controller.dart';
import 'package:zola/controller/sign_up_controller.dart';
import 'package:zola/services/otp.dart' as otpService;

class SignUpOne extends StatefulWidget {
  const SignUpOne({super.key});

  @override
  State<SignUpOne> createState() => _SignUpOneState();
}

class _SignUpOneState extends State<SignUpOne> {
  final emailController = TextEditingController();
  SignUpController signUpController = Get.put(SignUpController());
  FlowController flowController = Get.put(FlowController());

  String _errorMessage = "";
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    print("back");
                    context.go(RouteConst.login);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 67,
                ),
                Text(
                  "Đăng ký",
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: HexColor("#4f4f4f"),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 1,
                  ),
                  Text(
                    "Email",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: HexColor("#8d8d8d"),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: emailController,
                    onChanged: (value) {
                      validateEmail(value);
                    },
                    onSubmitted: (value) {},
                    cursorColor: HexColor("#4f4f4f"),
                    decoration: InputDecoration(
                      hintText: "hello@gmail.com",
                      fillColor: HexColor("#f0f3f1"),
                      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 15,
                        color: HexColor("#8d8d8d"),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Text(
                      _errorMessage,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  MyButton(
                      buttonText: 'Tiếp theo',
                      isLoading: _loading,
                      onPressed: () async {
                        if (emailController.value.text.isNotEmpty) {
                          try {
                            setState(() {
                              _loading = true;
                            });

                            signUpController
                                .updateEmail(emailController.value.text);
                            await otpService
                                .requestOtpRegister(emailController.value.text);
                            setState(() {
                              _loading = false;
                            });
							 flowController.setFlow(2);
                          } catch (e) {

                            setState(() {
                              _loading = false;
                              _errorMessage = "Email đã tồn tại trong hệ thống";
                            });
                          }
                        } else {
                          Get.snackbar("Error", "Bạn chưa điền email");
                        }

                      }),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                    child: Row(
                      children: [
                        Text("Đã có tài khoản?",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: HexColor("#8d8d8d"),
                            )),
                        TextButton(
                          child: Text(
                            "Đăng nhập",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: HexColor("#44564a"),
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "Chưa nhập email";
      });
    } else if (!EmailValidator.validate(val, true)) {
      setState(() {
        _errorMessage = "Định dạng email không hợp lệ";
      });
    } else {
      setState(() {
        _errorMessage = "";
      });
    }
  }
}
