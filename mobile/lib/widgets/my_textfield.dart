import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final Icon prefixIcon;
  final Function(String)? onChanged;
  final Function()? onCompleted;
  final String? errorText;

  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    required this.prefixIcon,
    this.onChanged,
    this.errorText,
    this.onCompleted,
  }) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      obscureText: widget.isPassword && _obscureText,
      cursorColor: HexColor("#4f4f4f"),
      decoration: InputDecoration(
        errorText: widget.errorText,
        errorBorder: widget.errorText != null
            ? OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(30),
              )
            : null,
        hintText: widget.hintText,
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
        prefixIcon: widget.prefixIcon,
        prefixIconColor: HexColor("#4f4f4f"),
        filled: true,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: HexColor("#4f4f4f"),
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}
