import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String labelText;
  final String hintText;

  const PasswordTextField({
    Key? key,
    required this.onChanged,
    required this.labelText,
    required this.hintText,
  }) : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isPasswordVisible = false;
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChanged,
      obscureText: !isPasswordVisible,
      controller: passwordController,
      decoration: InputDecoration(
        labelText: widget.labelText ?? 'Mật khẩu',
        hintText: widget.hintText ?? '',
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
        ),
      ),
    );
  }
}
