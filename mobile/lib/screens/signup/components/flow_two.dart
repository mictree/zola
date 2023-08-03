import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:zola/widgets/my_button.dart';
import 'package:zola/controller/flow_controller.dart';
import 'package:zola/controller/sign_up_controller.dart';
import 'package:zola/services/otp.dart' as otpService;

class SignUpTwo extends StatefulWidget {
  const SignUpTwo({super.key});

  @override
  State<SignUpTwo> createState() => _SignUpTwoState();
}

class _SignUpTwoState extends State<SignUpTwo> {
  final otpController = TextEditingController();
  FlowController flowController = Get.put(FlowController());
  SignUpController signUpController = Get.put(SignUpController());
  bool _isLoading = false;
  String _errorMessage = "";

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
                    flowController.setFlow(1);
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
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "OTP",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: HexColor("#8d8d8d"),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: otpController,
                    cursorColor: HexColor("#4f4f4f"),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      hintText: "000000",
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
                    isLoading: _isLoading,
                    onPressed: () async {
                      // check OTP if ok, go to next screen
                      try {
                        setState(() {
                          _isLoading = true;
                        });
                        await otpService.verifyRegisterOtp(
                            signUpController.signUpInfo.value.email,
                            otpController.text);
                        setState(() {
                          _isLoading = false;
                        });
                        flowController.setFlow(3);
                      } catch (e) {
                        print(e);
                        setState(() {
                          _isLoading = false;
                          _errorMessage = "OTP không đúng";
                        });
                      }
                      flowController.setFlow(3);
                    },
                    buttonText: 'Xác nhận',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
