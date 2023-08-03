import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:zola/controller/sign_up_controller.dart';
import 'package:zola/screens/signup/components/flow_one.dart';
import 'package:zola/screens/signup/components/flow_three.dart';
import 'package:zola/screens/signup/components/flow_two.dart';
import 'package:zola/controller/flow_controller.dart';

class SignUpBodyScreen extends StatefulWidget {
  const SignUpBodyScreen({super.key});

  @override
  State<SignUpBodyScreen> createState() => _SignUpBodyScreenState();
}

class _SignUpBodyScreenState extends State<SignUpBodyScreen> {
  FlowController flowController = Get.put(FlowController());
  SignUpController signUpController = Get.put(SignUpController());
  late int _currentFlow;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final valPasswordController = TextEditingController();
  @override
  void initState() {
    _currentFlow = FlowController().currentFlow;
    super.initState();
  }

  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
          );
        });
  }

  String _errorMessage = "";

  void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "Email can not be empty";
      });
    } else if (!EmailValidator.validate(val, true)) {
      setState(() {
        _errorMessage = "Invalid Email Address";
      });
    } else {
      setState(() {
        _errorMessage = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: HexColor("#34a9e5"),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
          shrinkWrap: true,
          reverse: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    Container(
						height: MediaQuery.of(context).size.height * 0.9,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: HexColor("#ffffff"),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: GetBuilder<FlowController>(
                          builder: (context) {
                            if (flowController.currentFlow == 1) {
                              return const SignUpOne();
                            } else if (flowController.currentFlow == 2) {
                              return const SignUpTwo();
                            } else {
                              return const SignUpThree();
                            }
                          },
                        )),
                    // Transform.translate(
                    //     offset: const Offset(0, -253),
                    //     child: Image.asset(
                    //       'assets/images/plants2.png',
                    //       scale: 1.5,
                    //       width: double.infinity,
                    //     )),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
