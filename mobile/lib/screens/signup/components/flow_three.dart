import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:zola/constants/route.dart';

import 'package:zola/widgets/my_button.dart';
import 'package:zola/controller/flow_controller.dart';
import 'package:zola/controller/sign_up_controller.dart';
import 'package:zola/services/auth.dart' as authService;

class SignUpThree extends StatefulWidget {
  const SignUpThree({super.key});

  @override
  State<SignUpThree> createState() => _SignUpThreeState();
}

class _SignUpThreeState extends State<SignUpThree> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController _dobController = TextEditingController();

  SignUpController signUpController = Get.find<SignUpController>();

  String basename(String path) => basename(path);

  FlowController flowController = Get.find<FlowController>();
  bool _loading = false;
  String _errorMessage = "";
  String rePassword = "";

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1999),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      _dobController.text = DateFormat("dd-MM-yyyy").format(picked).toString();
      signUpController.updateDob(_dobController.text);
    }
    //   setState(() {
    //     selectedDate = picked;
    //   });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
        child: ListView(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    flowController.setFlow(2);
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
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...[
                    Text(
                      "Email",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: HexColor("#8d8d8d"),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      readOnly: true,
                      initialValue: signUpController.signUpInfo.value.email,
                      cursorColor: HexColor("#4f4f4f"),
                      decoration: InputDecoration(
                        hintText: signUpController.signUpInfo.value.email,
                        fillColor: HexColor("#f0f3f1"),
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                  ],
                  ...[
                    Text(
                      "Họ và tên",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: HexColor("#8d8d8d"),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      onChanged: (value) {
                        signUpController.updateName(value);
                      },
                      onSubmitted: (value) {
                        signUpController.updateName(value);
                      },
                      cursorColor: HexColor("#4f4f4f"),
                      decoration: InputDecoration(
                        // hintText: "2020",
                        fillColor: HexColor("#f0f3f1"),
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                  ],
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Ngày sinh",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: HexColor("#8d8d8d"),
                    ),
                  ),
                  TextFormField(
                    readOnly: true,
                    controller: _dobController,
                    keyboardType: TextInputType.number,
                    cursorColor: HexColor("#4f4f4f"),
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                        child: const Icon(Icons.calendar_today),
                        onTap: () {
                          debugPrint('tapped');
                          _selectDate(context);
                        },
                      ),
                      // hintText: "2020",
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
                  Text(
                    "Mật khẩu",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: HexColor("#8d8d8d"),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    obscureText: true,
                    enableSuggestions: false,
                    onChanged: (value) {
                      signUpController.updatePassword(value);
                    },
                    onSubmitted: (value) {
                      signUpController.updatePassword(value);
                    },
                    cursorColor: HexColor("#4f4f4f"),
                    decoration: InputDecoration(
                      // hintText: "2020",
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
                  Text(
                    "Xác nhận Mật khẩu",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: HexColor("#8d8d8d"),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    onChanged: (value) {
                      setState(() {
                        rePassword = value;
                      });
                      if (rePassword !=
                          signUpController.signUpInfo.value.password) {
                        setState(() {
                          _errorMessage = "Mật khẩu không khớp";
                        });
                      } else {
                        setState(() {
                          _errorMessage = "";
                        });
                      }
                    },
                    onSubmitted: (value) {
                      setState(() {
                        rePassword = value;
                      });
                      if (rePassword !=
                          signUpController.signUpInfo.value.password) {
                        setState(() {
                          _errorMessage = "Mật khẩu không khớp";
                        });
                      } else {
                        setState(() {
                          _errorMessage = "";
                        });
                      }
                    },
                    cursorColor: HexColor("#4f4f4f"),
                    decoration: InputDecoration(
                      // hintText: "2020",
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
                    isLoading: _loading,
                    onPressed: () async {
                      try {
                        setState(() {
                          _loading = true;
                        });
                        var signUpInfo = signUpController.signUpInfo.value;
                        await authService.signUp(
                            signUpInfo.email,
                            signUpInfo.password,
                            signUpInfo.fullname,
                            signUpInfo.birthday);
                        setState(() {
                          _loading = false;
                        });
                        signUpController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Đăng ký thành công'),
                            action: SnackBarAction(
                              label: 'Đăng nhập',
                              onPressed: () {
                                context.go(RouteConst.login);
                              },
                            ),
                          ),
                        );

                        flowController.setFlow(1);

                        await Future.delayed(const Duration(seconds: 1));
                        context.go(RouteConst.login);
                      } catch (e) {
                        setState(() {
                          _loading = false;
                          _errorMessage = "Đăng ký thất bại";
                        });
                      }
                    },
                    buttonText: 'Đăng ký',
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
